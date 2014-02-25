#ifndef GUIGAMECONTROLLER_H
#define GUIGAMECONTROLLER_H

#include "GameCore.h"
#include "Player.h"

#include <QGuiApplication>
#include <QObject>
#include <QQuickView>
#include <QMediaPlayer>
#include <QThread>

#include "NetworkInterface.h"

class GuiGameController : public QObject, public GameCore {

    Q_OBJECT

    Q_PROPERTY( QList<int> opponentsTurn READ getOpponentsTurn )

    Q_PROPERTY( int winner READ getWinner )

protected:

    QGuiApplication* app;
    QQuickView* window;

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
    void setWindow(QQuickView* window);
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
    void setNetworkInterface(NetworkInterface*);
    void backToMainMenu();
};


#endif // GUIGAMECONTROLLER_H
