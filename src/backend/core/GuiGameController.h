#ifndef GUIGAMECONTROLLER_H
#define GUIGAMECONTROLLER_H

#include "GameCore.h"
#include "Player.h"

#include <QGuiApplication>
#include <QObject>
#include <QQuickView>
#include <QQuickItem>
#include <QMediaPlayer>
#include <QThread>

//#include "MonteCarloParallelAI.h"
#include "NetworkInterface.h"
#include "SmarterPlayer2.h"
#include "SmarterPlayer4.h"

typedef SmarterPlayer4 DefaultAIPlayer;


class Proxy : public QObject {

Q_OBJECT

public:

    virtual ~Proxy(){}


signals:

    //qml proxy
    void readyToStartOnePersonPlay();
    void readyToStartTwoPersonPlay();
    void changeSoundState();
    void changeGuiPlayerColor(int color);
    void readyToExitGame();
    void backToMainMenu();
    void sendPlayerName(QVariant playerName );
    void readyToOpenClaw(int qIndex, int pIndex, QVariant whichClaw );
    void enterNetworkLobby();
    void sendThisChallenge( QVariant stringAddressOfPlayerToChallenge );
    void challengeReceivedFromNetwork( QVariant challengerName, QVariant stringAddressOfPlayerWhoChallenged );
    void challengeWasAccepted();
    void challengeWasDeclined();
    void sendThisChallengeResponse( bool acceptChallenge );
    void sendThisNetworkMove( int quadrantIndex, int pieceIndex, int quadrantToRotate, int rotationDirection );
    void playerEnteredLobby( QVariant arrivingPlayerName, QVariant addressOfArrivingPlayer, int playerId );
    void playerLeftLobby( int playerId );
    void opponentDisconnected();
    void opponentReconnected();

    //GuiGameController proxy
    void readyForGuiMove();
    void gameIsOver();
    void registerGuiTurnWithBoard();
    void setGuiTurnRotation( int quadrantToRotate, int rotationDirection );
    void setGuiTurnHole( int qIndex, int pIndex );

};

class GuiGameController : public QObject, public GameCore {

    Q_OBJECT

    Q_PROPERTY( QList<int> opponentsTurn READ getOpponentsTurn )

    Q_PROPERTY( int winner READ getWinner )

protected:

    QGuiApplication* app;
    Proxy* gui;

    //player1 is in the Gui; his turn is too specialized to force into the player class
    Player* player2;

    PlayerColor guiPlayerColor;
    QString guiPlayerName;
    PlayerColor firstMover;
    bool isGuiPlayersTurn;
    bool isNetworkGame;
    QList<int> qOpponentsLastTurn;
    Turn qGuiTurn;

    NetworkInterface* net;

    QThread* pMusicThread;

    QMediaPlayer musicPlayer;

    void startNetworkGame();

public:

    //called from main
    GuiGameController( QGuiApplication* mainApp );
    void setWindow(Proxy* window);
    void setQApplication( QGuiApplication* qapp );

    //called from QML
    Q_INVOKABLE QList<int> getOpponentsTurn() const {
        return qOpponentsLastTurn;
    }

    Q_INVOKABLE int getWinner();

signals:

    void badMoveFromGui();
    void gameIsOver();
    void readyForGuiMove();
    void waitingForOpponentsMove();
    void challengeReceived();
    void challengeAccepted();
    void challengeDeclined();

public slots:



    //connected to Gui buttons
    void setGuiPlayerColor( int menuSelectedColor );
    void setFirstMovingPlayerColor( PlayerColor playerToMoveFirst );
    void setPlayer2( Player* );
    void startOnePersonPlay();
    void startTwoPersonPlay();
    void enterNetworkLobby();
    void togglePlayback();
    void exitGame();
    void setPlayerName(QVariant name);

    void registerOpponentsTurnWithBoard( Turn );
    void registerGuiTurnWithBoard();
    void setGuiTurnHole( int qIndex, int pIndex );
    void setGuiTurnRotation( int quadrantToRotate, int rotationDirection );

    //network slots
    void forwardChallengeResponse(bool accepted);
    void challengeResponseReceivedFromNetwork(bool);
    void networkTurnReceivedFromNetwork( int, int, int, int );
    void initialize();
    void setNetworkInterface();
    void setAIPlayer(Player*);
    void backToMainMenu();
};


class GuiProxy : public Proxy {

    Q_OBJECT

    GuiGameController* core;

public:

    //called from QML
    Q_INVOKABLE QList<int> getOpponentsTurn() const {
        return core->getOpponentsTurn();
    }

    Q_INVOKABLE int getWinner(){
        return core->getWinner();
    }

    ~GuiProxy(){}

    GuiProxy( GuiGameController* c, QQuickItem* gui){
        core = c;

        qDebug() << "connecting gui proxy signals";
        connect( gui,   SIGNAL( readyToStartOnePersonPlay() ),                      this,   SIGNAL( readyToStartOnePersonPlay() ));
        connect( gui,   SIGNAL( readyToStartTwoPersonPlay() ),                      this,   SIGNAL( readyToStartTwoPersonPlay() ));
        connect( gui,   SIGNAL( sendPlayerName( QVariant ) ) ,                      this,   SIGNAL( sendPlayerName( QVariant )  ));
        connect( gui,   SIGNAL( enterNetworkLobby() ),                              this,   SIGNAL( enterNetworkLobby() ));
        connect( gui,   SIGNAL( changeSoundState() ),                               this,   SIGNAL( changeSoundState() ));
        connect( gui,   SIGNAL( changeGuiPlayerColor( int )),                       this,   SIGNAL( changeGuiPlayerColor( int ) ));
        connect( gui,   SIGNAL( readyToExitGame() ),                                this,   SIGNAL( readyToExitGame() ));
        connect( gui,   SIGNAL( backToMainMenu() ),                                 this,   SIGNAL( backToMainMenu() ));
        connect( gui,   SIGNAL(sendThisChallenge(QVariant)),                        this,   SIGNAL(sendThisChallenge(QVariant)));
        connect( gui,   SIGNAL(sendThisChallengeResponse(bool)),                    this,   SIGNAL(sendThisChallengeResponse(bool)));
        connect( gui,   SIGNAL(sendThisNetworkMove( int, int, int, int )),          this,   SIGNAL(sendThisNetworkMove( int, int, int, int )));
        connect( this,  SIGNAL(challengeReceivedFromNetwork(QVariant, QVariant)),   gui,    SIGNAL(challengeReceivedFromNetwork(QVariant, QVariant)));
        connect( this,  SIGNAL( challengeWasAccepted()),                            gui,    SIGNAL(challengeWasAccepted() ));
        connect( this,  SIGNAL( challengeWasDeclined()),                            gui,    SIGNAL(challengeWasDeclined()));
        connect( this,  SIGNAL( playerEnteredLobby(QVariant, QVariant, int )),      gui,    SIGNAL(playerEnteredLobby(QVariant, QVariant, int )));
        connect( this,  SIGNAL( playerLeftLobby(int)),                              gui,    SIGNAL(playerLeftLobby(int)));
        connect( this,  SIGNAL(opponentReconnected()),                              gui,    SIGNAL(opponentReconnected()));
        connect( this,  SIGNAL(opponentDisconnected()),                             gui,    SIGNAL(opponentDisconnected()));

        qDebug() << "connecting core proxy signals";
        connect( core,  SIGNAL( readyForGuiMove() ),                                this,   SIGNAL(readyForGuiMove()),          Qt::QueuedConnection );
        connect( core,  SIGNAL( gameIsOver() ),                                     this,   SIGNAL(gameIsOver()),               Qt::QueuedConnection );
        connect( this,  SIGNAL( registerGuiTurnWithBoard()),                        core,   SLOT( registerGuiTurnWithBoard()),  Qt::QueuedConnection );
        connect( this,  SIGNAL(setGuiTurnRotation(int, int)),                       core,   SLOT(setGuiTurnRotation(int,int)),  Qt::QueuedConnection );
        connect( this,  SIGNAL(setGuiTurnHole(int,int)),                            core,   SLOT(setGuiTurnHole(int,int)),      Qt::QueuedConnection );

    }


};

#endif // GUIGAMECONTROLLER_H
