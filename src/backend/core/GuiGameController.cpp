#include "GuiGameController.h"
#include "Turn.h"

#include <QQuickItem>
#include <QQuickView>
#include <QGuiApplication>
#include <QQmlEngine>
#include <QtQml>
#include <QGlobal.h>
#include <QTime>


//called from main
GuiGameController::GuiGameController( QGuiApplication* mainApp ) {
    guiPlayerColor = PlayerColor::BLACK;
    firstMover = PlayerColor::WHITE;

    player2 = nullptr;
    net = nullptr;
    isNetworkGame = false;
    app = mainApp;
}

void GuiGameController::setGuiTurnRotation( int quadrantToRotate, int rotationDirection ){
    qDebug() << "setting quadrantToRotate for gui in gameController with  value of " << quadrantToRotate;
    qGuiTurn.setQuadrantToRotate(quadrantToRotate);
    qGuiTurn.setRotationDirection( (Direction) rotationDirection);
}

void GuiGameController::setGuiTurnHole( int qIndex, int pIndex ){
    BoardLocation bl;
    bl.quadrantIndex = qIndex;
    bl.pieceIndex = pIndex;
    qGuiTurn.setHole(bl);

    //checks for case when a player wins before a rotate
    GameData test = copyCurrentBoard().checkEarlyWin( bl, guiPlayerColor );

    if( test.winner == guiPlayerColor ){
        gameData = test;

        if( isNetworkGame ){

            //we won without rotating, so we need to inform the other player
            net -> sendGuiTurn( bl.quadrantIndex, bl.pieceIndex, DONT_ROTATE_CODE, Direction::NO_DIRECTION );
        }

        emit gameIsOver();
    }
}

int GuiGameController::getWinner(){

    //first number be the winner
        //where WHITE is 0 and BLACK is 1 or -1 for draw (NONE)

    return (int) gameData.winner;
}

int GuiGameController::getLastMoverColor(){
    //white/teal is 0, black/purple is 1
    return (int) gameData.lastMover;
}

void GuiGameController::setWindow(Proxy* g){

    gui = g;

    qDebug() << "connecting window signals";
    connect(gui, SIGNAL( readyToStartOnePersonPlay( int,int )), this, SLOT( startOnePersonPlay( int,int ) ),Qt::QueuedConnection  );
    connect(gui, SIGNAL( readyToStartTwoPersonPlay() ),     this, SLOT( startTwoPersonPlay() ),     Qt::QueuedConnection  );
    connect(gui, SIGNAL( sendPlayerName( QVariant ) ) ,     this, SLOT( setPlayerName( QVariant ) ),Qt::QueuedConnection  );
    connect(gui, SIGNAL( enterNetworkLobby() ),             this, SLOT( enterNetworkLobby() ),      Qt::QueuedConnection  );
    connect(gui, SIGNAL( readyToExitGame() ),               this, SLOT( exitGame() ),               Qt::QueuedConnection  );
    connect(gui, SIGNAL( leaveLobby() ),                this, SLOT( leaveLobby() ),         Qt::QueuedConnection  );

}

void GuiGameController::setPlayerName(QVariant name){

    guiPlayerName = name.toString();

    assert( net != nullptr );
    net -> setNetworkPlayerName(name);

}

void GuiGameController::initialize(){
    qsrand(QTime::currentTime().msec());
    setNetworkInterface();
}

//must be called after setWindow
void GuiGameController::setNetworkInterface(){
    if( net == nullptr){

        net = new NetworkInterface(this);

        qDebug() << "connecting network signals";

        //gameController -> network
        connect( this, SIGNAL(gameIsOver()), net, SLOT( tellMeGameIsOver()) );

        //network -> GUI
        connect( net,   SIGNAL(opponentDisconnectedEarly()),                    gui,    SIGNAL(opponentDisconnected()) );
        connect( net,   SIGNAL(connectionReestablished()),                      gui,    SIGNAL(opponentReconnected()) );
        connect( net,   SIGNAL( challengeReceived(QVariant, QVariant) ),        gui,    SIGNAL(challengeReceivedFromNetwork(QVariant, QVariant)),   Qt::QueuedConnection );
        connect( net,   SIGNAL( challengeResponseReceived(bool)),               this,   SLOT(challengeResponseReceivedFromNetwork(bool)),           Qt::QueuedConnection );
        connect( net,   SIGNAL( networkTurnReceived(int,int,int,int) ),         this,   SLOT(networkTurnReceivedFromNetwork(int,int,int,int)),      Qt::QueuedConnection );
        connect( this,  SIGNAL( challengeAccepted()),                           gui,    SIGNAL(challengeWasAccepted() ),                            Qt::QueuedConnection );
        connect( this,  SIGNAL( challengeDeclined()),                           gui,    SIGNAL(challengeWasDeclined()) ,                            Qt::QueuedConnection );
        connect( net,   SIGNAL( playerJoinedNetwork(QVariant, QVariant, int, bool )), gui,    SIGNAL(playerEnteredLobby(QVariant, QVariant, int, bool )),       Qt::QueuedConnection );
        connect( net,   SIGNAL( playerLeftNetwork(int)),                        gui,    SIGNAL(playerLeftLobby(int)));
        connect( net,   SIGNAL( networkPlayerBecameBusy(QVariant)),             gui,    SIGNAL(networkPlayerBecameBusy(QVariant)),                  Qt::QueuedConnection );
        connect( net,   SIGNAL( networkPlayerNoLongerBusy(QVariant)),           gui,    SIGNAL(networkPlayerNoLongerBusy(QVariant)),                Qt::QueuedConnection );
        //GUI -> network
        connect(gui, SIGNAL(sendThisChallenge(QVariant)),               net,    SLOT(sendChallenge(QVariant)),              Qt::QueuedConnection );
        connect(gui, SIGNAL(sendThisChallengeResponse(bool)),           this,   SLOT(forwardChallengeResponse(bool)),       Qt::QueuedConnection );
        connect(gui, SIGNAL(sendThisNetworkMove( int, int, int, int )), net,    SLOT(sendGuiTurn( int, int, int, int )),    Qt::QueuedConnection );

    }else{
        qDebug() << "WEIRD, net should've been null";
    }

}

void GuiGameController::leaveLobby(){
    qDebug() << "game controller telling network to leave lobby...";
    if( isNetworkGame ){
        isNetworkGame = false;
        net -> leaveLobby();
    }
    else{
        qDebug() << "we weren't just in a network game - ERROR??";
    }

}

//intercepting to get new game ready
void GuiGameController::forwardChallengeResponse(bool accepted){

    if( accepted ){
        //for our program, the challenged player moves first
        firstMover = PlayerColor::WHITE;
        guiPlayerColor = PlayerColor::WHITE;

        startNetworkGame( WHITE );
    }

    net -> sendChallengeResponse( accepted );
}

void GuiGameController::challengeResponseReceivedFromNetwork(bool challengeWasAccepted){

    qDebug() << "challengeWasAccepted = " << (challengeWasAccepted?"true":"false");

    //start a new game according to parameters
    if( challengeWasAccepted ){
        startNetworkGame( BLACK );

        //for our program, that the challenged player moves first
        firstMover = PlayerColor::BLACK;
        guiPlayerColor = PlayerColor::WHITE;


        emit challengeAccepted();
    }
    else{
        emit challengeDeclined();
    }
}

void GuiGameController::networkTurnReceivedFromNetwork( int quadrantIndex, int pieceIndex, int quadrantToRotate, int rotationDirection ){

    setMovingPlayerColor(BLACK);

    //network opponent is always BLACK to the game core
    registerOpponentsTurnWithBoard( Turn(quadrantIndex, pieceIndex, quadrantToRotate, rotationDirection, PlayerColor::BLACK ) );


    if( isGameOver() ){
         emit gameIsOver();
    }
    else{
        emit readyForGuiMove();
    }

}


void GuiGameController::startOnePersonPlay( int aiLevel, int menuSelectedColor ) {

    isVersusGame = false;
    isNetworkGame = false;

    qDebug() << "in startOnePersonPlay, aiLevel is " << aiLevel << " and menuSelectedColor is " << menuSelectedColor;

    assert (aiLevel == 1 || aiLevel == 2 || aiLevel == 3);
    if ( aiLevel == 1 ){
        setPlayer2(&easyAi);
    }
    else if ( aiLevel == 2 ) {
        setPlayer2(&mediumAi);
    }
    else {
        setPlayer2(&hardAi);
    }

    assert( menuSelectedColor == 0 or menuSelectedColor == 1 );

    guiPlayerColor = static_cast<PlayerColor>(menuSelectedColor);
    player2 -> setColor(util.opposite(guiPlayerColor));
    qDebug() << "player colors are set";

    GameCore::startNewGame();

    qGuiTurn.setPieceColor( guiPlayerColor );

    if( guiPlayerColor != firstMover ){
        registerOpponentsTurnWithBoard ( player2 -> getMove( copyCurrentBoard() ) );
    }

    //default to gui move
    emit readyForGuiMove();
}

void GuiGameController::startTwoPersonPlay() {
    GameCore::startNewGame();

    isVersusGame = true;
    isNetworkGame = false;
    qGuiTurn.setPieceColor( PlayerColor::WHITE );
    firstMover = PlayerColor::WHITE;
    guiPlayerColor = PlayerColor::WHITE;
    setMovingPlayerColor(firstMover);

    emit readyForVersusMove();
}

void GuiGameController::enterNetworkLobby() {
    qDebug() << "Entering network lobby...";
    isNetworkGame = true;
    net -> enterLobby();
}

void GuiGameController::startNetworkGame( PlayerColor myColor ) {

    GameCore::startNewGame();

    qOpponentsLastTurn.clear();

    qGuiTurn.setPieceColor( myColor );
    guiPlayerColor = myColor;

    if( guiPlayerColor == firstMover ){
        emit readyForGuiMove();
    }
    else{
        emit waitingForOpponentsMove();
    }

}

void GuiGameController::exitGame() {

    QThread* coreThread = this -> thread();
    moveToThread(QGuiApplication::instance()->thread());

    if( net != nullptr ){
        net -> deleteLater();
        connect( net, SIGNAL(destroyed()), coreThread, SLOT(quit()) );
    }

    connect( coreThread, SIGNAL(finished()), app, SLOT(quit()) );
}


void GuiGameController::setPlayer2( Player* p ){
    player2 = p;
}

//this function oversees the sequence of gameplay
void GuiGameController::registerGuiTurnWithBoard(){

    assert( ! qGuiTurn.isEmpty() );

    registerTurnWithBoard( qGuiTurn );

    if( isGameOver() && !isNetworkGame ){
         emit gameIsOver();
    }
    else if( isVersusGame ){
        guiPlayerColor = util.opposite(guiPlayerColor);
        qGuiTurn.setPieceColor( guiPlayerColor );
        emit readyForVersusMove();
    }
    else{

        copyCurrentBoard().print();

        //network moves are registered elsewhere.
        if( !isNetworkGame ){

            registerOpponentsTurnWithBoard( player2 -> getMove( copyCurrentBoard() ) );

            if( isGameOver() ){
                 emit gameIsOver();
            }

            copyCurrentBoard().print();
            emit readyForGuiMove();
        }
        else{
            net -> sendGuiTurn( qGuiTurn.getHole().quadrantIndex, qGuiTurn.getHole().pieceIndex, qGuiTurn.getQuadrantToRotate(), qGuiTurn.getRotationDirection() );

            if( isGameOver() ){
                 emit gameIsOver();
            }
            else{
                emit waitingForOpponentsMove();
            }
        }
     }
 }

void GuiGameController::setFirstMovingPlayerColor( PlayerColor playerToMoveFirst ){
    setMovingPlayerColor(playerToMoveFirst);
}

void GuiGameController::registerOpponentsTurnWithBoard(Turn opponentsMove ) {
    //this will only be called by a non-gui player

    //qDebug() << "registering oppenents turn with board";

    //strip a rotation out of AI move if it's an early win (ai sends rotations, we have to hide them if they won before it rotated
    if( copyCurrentBoard().checkEarlyWin(opponentsMove.getHole(),opponentsMove.getPieceColor()).winner == opponentsMove.getPieceColor() ){
        opponentsMove.setQuadrantToRotate(DONT_ROTATE_CODE);
    }

    GameCore::registerTurnWithBoard(opponentsMove);


    //making sure that this only gets called with the opponents move
    if( opponentsMove.getPieceColor() == guiPlayerColor ){
        assert(false);
    }

    if( qOpponentsLastTurn.empty() ){
        qOpponentsLastTurn.append( opponentsMove.getHole().quadrantIndex );
        qOpponentsLastTurn.append( opponentsMove.getHole().pieceIndex );
        qOpponentsLastTurn.append( opponentsMove.getQuadrantToRotate() );
        qOpponentsLastTurn.append( opponentsMove.getRotationDirection() );
    }
    else{
        qOpponentsLastTurn[0] = opponentsMove.getHole().quadrantIndex;
        qOpponentsLastTurn[1] = opponentsMove.getHole().pieceIndex;
        qOpponentsLastTurn[2] = opponentsMove.getQuadrantToRotate();
        qOpponentsLastTurn[3] = opponentsMove.getRotationDirection();
    }
}
