#ifndef NETWORKINTERFACE_H
#define NETWORKINTERFACE_H

#include <QStack>
#include <QMap>
#include <QHash>
#include <QUdpSocket>
#include <QTimer>
#include <QTime>
#include <QGlobal.h>
#include <QtConcurrent>
#include <QFuture>
#include <QThread>
#include <QNetworkInterface>

#include <iostream>
#include <functional>

#include "Turn.h"
#include "PentagoNetworkUtil.h"
#include "Transaction.h"
#include "Barrager.h"

using namespace PentagoNetworkUtil;

class NetworkInterface : public QObject {

    Q_OBJECT

    typedef QStack<Transaction> TxStack;

    NetworkPlayerInfo myInfo;
    bool networkIsActive;
    bool networkGameIsOver;

    QMap< QTimer*, NetworkPlayerInfo > timerPlayerMap;
    QMap< NetworkPlayerInfo, QTimer* > playerTimerMap;
    QUdpSocket announceSocket;
    QTimer announceTimer;

    QUdpSocket gameListenSocket;
    QUdpSocket gameSendSocket;



    TxStack receivedFromConnectedPlayerStack;
    TxStack sentToConnectedPlayerStack;

    NetworkPlayerInfo connectedPlayerInfo;
    bool waitingOnPlayerToReconnect;
    Barrager barrager;

public:

    NetworkInterface( QObject* parent = NULL )
        : QObject(parent),
          networkIsActive(false),
          announceSocket(this),
          announceTimer(this),
          gameListenSocket(this),
          gameSendSocket(this),

          barrager(this,
                   [&](Transaction t){

                       if( connectedPlayerIsConnected() ){
                           QByteArray datagram = t.toByteArray();
                           gameSendSocket.writeDatagram( datagram.data(), datagram.size(), QHostAddress(connectedPlayerInfo.address), GAME_PORT );
                       }
                       else{
                           qDebug() << "oops, player to barrage is disconnected!";
                       }

                   })
        {
        gameListenSocket.bind( QHostAddress::Any, GAME_PORT, QAbstractSocket::DefaultForPlatform );
        announceSocket.bind( ANNOUNCE_PORT, QUdpSocket::ShareAddress );

        qDebug() << "initializing network slots and signals";
        connect(&announceSocket, SIGNAL(readyRead()), this, SLOT(processIncomingAnnounces()) );
        connect(&gameListenSocket, SIGNAL(readyRead()), this, SLOT(processIncomingGameTransactions()) );
        connect(&gameSendSocket, SIGNAL(disconnected()), this, SLOT(closeSocket()));
        connect(&gameListenSocket, SIGNAL(disconnected()), this, SLOT(closeSocket()));
        connect(&announceSocket, SIGNAL(disconnected()), this, SLOT(closeSocket()));
        connect(&announceTimer, SIGNAL(timeout()), this, SLOT(broadcastAnnounce()));

        myInfo.id = qrand();

        qDebug() << "my id is " << myInfo.id;

        for (const QHostAddress &address : QNetworkInterface::allAddresses()) {

            if ( address.protocol() == QAbstractSocket::IPv4Protocol && address != QHostAddress(QHostAddress::LocalHost) ){
                 qDebug() << "my address is " << address.toString();
                 myInfo.address = address.toIPv4Address();
            }
        }


    }



signals:

    void challengeReceived(QVariant name, QVariant address);
    void challengeResponseReceived(bool accepted);
    void networkTurnReceived( int, int, int, int ); //turn in int form
    void playerLeftNetwork( int id );
    void playerJoinedNetwork( QVariant name, QVariant address, int id );
    void opponentDisconnectedEarly();
    void connectionReestablished();

public slots:


    void setNetworkPlayerName( QVariant nameFromGui ){
        QString name = nameFromGui.toString();
        memcpy( myInfo.name, name.toStdString().c_str(), MAX_PLAYER_NAME_LENGTH - 1 );
    }

    //gameController calls this when the GUI chooses a turn
    void sendGuiTurn( int q,int p,int qr,int rd ){

        qDebug() << "sending our turn...";

        Transaction networkTurnTransaction;

        networkTurnTransaction.transactionType = TransactionType::NETWORK_TURN;
        networkTurnTransaction.author = myInfo;
        networkTurnTransaction.data.turn = Turn( q, p, qr, rd, PlayerColor::BLACK );
        networkTurnTransaction.seal = freshSeal();

        sendTransaction( networkTurnTransaction );
    }


    void enterLobby(){
        networkGameIsOver = false;
        networkIsActive = true;

        //this is the timer that sends out announces every ANNOUNCE_INTERVAL milliseconds
        announceTimer.start( ANNOUNCE_INTERVAL );
    }

    void tellMeGameIsOver(){
        if( networkIsActive && !networkGameIsOver ){
            networkGameIsOver = true;
            forgetAllAboutPlayer(connectedPlayerInfo);
            qDebug() << "network interface knows that game is over!";
        }
    }

    void leaveLobby(){

        qDebug() << "leaving lobby... receivedFromConnectedPlayerStack.size() = " << receivedFromConnectedPlayerStack.size() << " and sentToConnectedPlayerStack.size() = " << sentToConnectedPlayerStack.size();

        if( connectedPlayerIsConnected() ){
            terminateConnectionToPlayer();
        }
        else{
            qDebug() << "left lobby and no player was connected.";
        }

         //all timers will timeout and everyone will disconnect when this is set to false
         networkIsActive = false;

    }

    void broadcastAnnounce(){
        if( networkIsActive ){
            Transaction t(myInfo);
            t.transactionType = Transaction::TransactionType::ANNOUNCE;

            QByteArray datagram = t.toByteArray();

            announceSocket.writeDatagram( datagram.data(), datagram.size(), QHostAddress::Broadcast, ANNOUNCE_PORT );
        }
    }

    void handleAnnounce( Transaction announceTransaction ){

        QTimer* pTimer = playerTimerMap[announceTransaction.author];

        if( pTimer == nullptr ){
            qDebug() << announceTransaction.author.name << " has connected!";

            QVariant vName(QString(announceTransaction.author.name));
            QVariant vAddress(QHostAddress(announceTransaction.author.address).toString());

            emit playerJoinedNetwork( vName, vAddress, announceTransaction.author.id  );

            qDebug() << "making new QTimer for " << announceTransaction.author.name;
            pTimer = new QTimer(this);
            pTimer -> setSingleShot(true);

            timerPlayerMap[pTimer] = announceTransaction.author;
            playerTimerMap[ announceTransaction.author] = pTimer;

            connect( pTimer, SIGNAL(timeout()), this, SLOT( playerDisconnected() ) );

            //start the timer associated with that player
            pTimer -> start( MAX_WAIT_TIME );
        }
        else if( pTimer -> timerId() != -1 ){
            pTimer -> start( MAX_WAIT_TIME );
        }else{
            //qDebug() << "pTIMER WE HAVE MAKE CATCH YOU NOW!!!!!!";
            //start the timer associated with that player
            pTimer -> start( MAX_WAIT_TIME );
        }
    }

    WaxSeal freshSeal(){
        return qrand();
    }

    void connectToPlayer( QHostAddress address ){

        qDebug() << "connecting to address " << address.toString();
        gameSendSocket.bind(address, GAME_PORT );
        waitingOnPlayerToReconnect = false;
        connectedPlayerInfo.address = address.toIPv4Address();

    }

    void barrageConnectedPlayer( Transaction t, std::function<void()> onComplete = []{} ){
        barrager.setTransaction( t );
        barrager.unleash(onComplete);
    }


    //this starts up the gameSocket and is
    //the only game Transaction-sending function
    //that needs an IPv4 address as an argument
    void sendChallenge( QVariant addressString ){

        if( !receivedFromConnectedPlayerStack.empty() &&
            receivedFromConnectedPlayerStack.top().transactionType == TransactionType::CHALLENGE_RESPONSE &&
            !receivedFromConnectedPlayerStack.top().data.challengeResponse.isAccepted  )
        {
            qDebug() << "Clearing receivedFromConnectedPlayerStack and connection because our last challenge was declined.";
            terminateConnectionToPlayer();
        }

        auto address = QHostAddress(addressString.toString());

        //button has been clicked in the gui and sends
        //the IP address back down to c++

        if ( QHostAddress(connectedPlayerInfo.address) != address ){
            connectToPlayer( address );

            Transaction challengeTransaction;
            challengeTransaction.author = myInfo;
            challengeTransaction.seal = freshSeal();
            challengeTransaction.transactionType = Transaction::CHALLENGE;
            //challenge transaction's union data doesn't carry anything meaningful

            sendTransaction( challengeTransaction );

        }
        else{
            qDebug() << "hmm, tried to send a challenge during other connection.";
        }


        //we need to set a timeout for (busy) in case he is already being challenged
    }

    void handleChallenge( Transaction challengeTransaction ){

        qDebug() << "challenge received";

        assert(receivedFromConnectedPlayerStack.size() == 1);

        qDebug() << "connecting to player's gameListenSocket";
        //now our game socket is committed to this player
        connectToPlayer( QHostAddress(challengeTransaction.author.address) );


        //this will go back to the gameController which will
        //set up the challenge in the GUI
        emit challengeReceived( QVariant(QString(challengeTransaction.author.name)), QVariant(QHostAddress(challengeTransaction.author.address).toString()) );

    }

    //connected to a gameController signal
    void sendChallengeResponse( bool acceptChallenge ){

        qDebug() << "sending challenge response, accepted = " << (acceptChallenge? "true":"false");

        //the game controller will set up the game when he sends the signal connected to this slot

        Transaction responseTransaction;
        responseTransaction.author = myInfo;
        responseTransaction.transactionType = TransactionType::CHALLENGE_RESPONSE;
        responseTransaction.seal = freshSeal();
        responseTransaction.data.challengeResponse.isAccepted = acceptChallenge;


        //don't want to be sending a challenge response at the wrong point in gameplay
        assert( receivedFromConnectedPlayerStack.top().transactionType == TransactionType::CHALLENGE );
        assert( receivedFromConnectedPlayerStack.size() == 1 );

        std::function<void()> onComplete;

        if( !acceptChallenge ){
            onComplete = [&]{
                terminateConnectionToPlayer();
            };
        }
        else{
            onComplete = []{};
        }


        sendTransaction( responseTransaction, onComplete );

    }

    void terminateConnectionToPlayer(){
        qDebug() << "terminating connection to " << connectedPlayerInfo.name;
        receivedFromConnectedPlayerStack.clear();
        sentToConnectedPlayerStack.clear();
        connectedPlayerInfo = NetworkPlayerInfo();
        disconnectGameSocket();
    }

    void sendTransaction( Transaction t, std::function<void()> onComplete = []{} ){

        if( connectedPlayerIsConnected() ){
            sentToConnectedPlayerStack.push( t );

            qDebug () << "barraging address " << QHostAddress(connectedPlayerInfo.address).toString();

            //sends over the network with this call
            barrageConnectedPlayer( t, onComplete );


        }
        else {
            qDebug() << "thought player was connected!!!";
            //we need to handle this - when player disconnects while waiting on a challenge response
        }
    }

    void handleChallengeResponse( Transaction challengeResponseTransaction ){

        qDebug() << "challenge response received, isAccepted = " << (challengeResponseTransaction.data.challengeResponse.isAccepted?"true":"false");

        if( challengeResponseTransaction.data.challengeResponse.isAccepted ){

            //will be connected to gameController, which will start a new game
            emit challengeResponseReceived(true);
        }

        else {
            //we leave it on the stack to prevent barrage abuse but it is about to be cleared
            emit challengeResponseReceived(false);
        }
    }

    void disconnectGameSocket(){
        qDebug() << "disconnecting gameSendSocket...";
        gameSendSocket.disconnectFromHost();
    }

    bool connectedPlayerIsConnected(){
        return connectedPlayerInfo.address != 0;
    }

    void forgetAllAboutPlayer(NetworkPlayerInfo disconnectedPlayerInfo){
        qDebug() << "forgetting all about player";
        auto pTimer = playerTimerMap[disconnectedPlayerInfo];

        if( pTimer != nullptr ){
            pTimer -> deleteLater();
            timerPlayerMap[pTimer] = NetworkPlayerInfo();
            playerTimerMap[disconnectedPlayerInfo] = nullptr;
        }
        else{
            qDebug() << "WARNING from NetworkInterface, tried to forget about unknown player!!";
        }

    }

    void playerDisconnected(){
        QObject* sentBy = QObject::sender();

        //this slot is connected to QTimer::timeout().
        //We need to get the pointer to the timer object that sent the signal
        assert( sentBy != 0 );
        QTimer* pTimer = qobject_cast<QTimer*>(sentBy);
        assert( pTimer != NULL );

        if( pTimer->isActive() ) {
            qDebug() << "WHY U R HAVE ACTIVE, PTIMER!!!!";
            pTimer -> stop();
        }



        NetworkPlayerInfo disconnectedPlayerInfo = timerPlayerMap[pTimer];

        qDebug() << "player " << disconnectedPlayerInfo.name << " was disconnected";
        emit playerLeftNetwork( disconnectedPlayerInfo.id );


        if( disconnectedPlayerInfo.address == connectedPlayerInfo.address ){


            //stupid ugly special case with a "pointless" challenge decline sitting on top of the stack
            if( !receivedFromConnectedPlayerStack.empty() &&
                receivedFromConnectedPlayerStack.top().transactionType == TransactionType::CHALLENGE_RESPONSE &&
                !receivedFromConnectedPlayerStack.top().data.challengeResponse.isAccepted  )
            {
                qDebug() << "disconnectedPlayer was involved in something UNimportant. no problem. ";
                terminateConnectionToPlayer();
                forgetAllAboutPlayer(disconnectedPlayerInfo);
            }
            else{

                if( networkGameIsOver ){
                    qDebug() << "disconnectedPlayer finished the game, no problem. ";


                }
                else{
                    //TODO: handle disconnect/reconnect
                    qDebug() << "disconnectedPlayer was involved in something important!!!!";
                    emit opponentDisconnectedEarly();
                    terminateConnectionToPlayer();
                    forgetAllAboutPlayer(disconnectedPlayerInfo);
                }
            }
        }

        else{
            forgetAllAboutPlayer(disconnectedPlayerInfo);
        }

    }

    void processIncomingGameTransactions() {

        while ( gameListenSocket.hasPendingDatagrams() ) {
            //qDebug() << "processing game tx";
            QByteArray datagram;

            assert( gameListenSocket.pendingDatagramSize() == sizeof(Transaction) );

            datagram.resize( sizeof(Transaction) );

            //fill QByteArray
            gameListenSocket.readDatagram( datagram.data(), datagram.size() );

            Transaction receivedTransaction( datagram );

            //if the top of our stack is a challenge decline and what we're receiving isn't from the same barrage then clear everything
            //(this if here filters out challenge decline barrages from our handling code below)
            if( !receivedFromConnectedPlayerStack.empty() &&
                receivedFromConnectedPlayerStack.top().transactionType == TransactionType::CHALLENGE_RESPONSE &&
                !receivedFromConnectedPlayerStack.top().data.challengeResponse.isAccepted &&
                receivedFromConnectedPlayerStack.top().seal != receivedTransaction.seal ){

                qDebug() << "connectedPlayerInfo.id = " << connectedPlayerInfo.id;
                qDebug() << "receivedFromConnectedPlayerStack.top().author.id = " << receivedFromConnectedPlayerStack.top().author.id;
                assert(connectedPlayerInfo.id == receivedFromConnectedPlayerStack.top().author.id );
                terminateConnectionToPlayer();
            }

            if( networkIsActive && (receivedFromConnectedPlayerStack.isEmpty() || ( receivedFromConnectedPlayerStack.top().seal != receivedTransaction.seal ))){

                /*if( !receivedFromConnectedPlayerStack.isEmpty()){
                  qDebug() << "top of stack has seal " << receivedFromConnectedPlayerStack.top().seal;
                }
                else{
                    qDebug() << "receivedFromConnectedPlayerStack is empty.";
                }*/

                receivedFromConnectedPlayerStack.push( receivedTransaction );

                if( connectedPlayerInfo.id != receivedTransaction.author.id ){
                    connectedPlayerInfo = receivedTransaction.author;
                }

                qDebug() << "received fresh tx with seal " << receivedTransaction.seal;

                //will need a switch here to determine transaction type
                switch( receivedTransaction.transactionType ){

                    case TransactionType::ANNOUNCE:
                        qDebug() << "Error: announce sent to GAME_PORT!!";
                        assert(false);
                        break;

                    case TransactionType::CHALLENGE:
                        handleChallenge( receivedTransaction );
                        break;


                    case TransactionType::CHALLENGE_RESPONSE:
                        handleChallengeResponse( receivedTransaction );
                        break;

                    case TransactionType::NETWORK_TURN:
                        qDebug() << "received network turn...";
                        if( receivedTransaction.author.address == connectedPlayerInfo.address ){
                            int q,p,qr,rd;
                            q = receivedTransaction.data.turn.getHole().quadrantIndex;
                            p = receivedTransaction.data.turn.getHole().pieceIndex;
                            qr = (int)receivedTransaction.data.turn.getQuadrantToRotate();
                            rd = (int)receivedTransaction.data.turn.getRotationDirection();
                            qDebug() << "emitting networkTurnReceived";
                            emit networkTurnReceived( q,p,qr,rd );
                        }
                        else{
                            qDebug() << "received turn from unconnected player " << receivedTransaction.author.name;
                        }
                        break;

                    default:
                        qDebug() << "Error: unknown transaction type received";
                        assert(false);
                        break;
                }

                receivedTransaction.print();
            }
        }
    }

    void processIncomingAnnounces() {

        while ( announceSocket.hasPendingDatagrams() ) {

            QByteArray datagram;

            /*#if PENTAGO_RELEASE == false
            if(announceSocket.pendingDatagramSize() != sizeof(Transaction)){
                assert( announceSocket.pendingDatagramSize() == sizeof(Transaction) );
            }
            #endif*/

            datagram.resize( sizeof(Transaction) );

            //fill QByteArray
            announceSocket.readDatagram( datagram.data(), datagram.size() );

            Transaction receivedTransaction( datagram );

            if( networkIsActive && receivedTransaction.author.id != myInfo.id ){

                //QtConcurrent::run(this, &NetworkInterface::handleAnnounce, receivedTransaction);
                handleAnnounce( receivedTransaction );
            }

            //receivedTransaction.print();
        }
    }

    void closeSocket(){

        QString sentName = "UNKNOWN";
        QObject* sentBy = QObject::sender();

        //this slot is connected to QTimer::timeout().
        //We need to get the pointer to the timer object that sent the signal
        assert( sentBy != 0 );
        QUdpSocket* socket = qobject_cast<QUdpSocket*>(sentBy);
        assert( socket != NULL );

        if( sentBy == &announceSocket ){
            sentName = "announceSocket";
        }
        else if( sentBy == &gameSendSocket ){
            sentName == "gameSendSocket";
        }
        else if( sentBy == &gameListenSocket ){
            sentName == "gameListenSocket";
        }

        qDebug() << "closing socket: " << sentName;
        socket -> close();
    }

};



#endif // NETWORKINTERFACE_H
