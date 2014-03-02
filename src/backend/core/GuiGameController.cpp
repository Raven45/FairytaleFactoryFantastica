#include "GuiGameController.h"
#include "Turn.h"

#include <QQuickItem>
#include <QQuickView>
#include <QGuiApplication>
#include <QQmlEngine>
#include <QtQml>

//called from main
GuiGameController::GuiGameController( QGuiApplication* mainApp ) {
    guiPlayerColor = PlayerColor::BLACK;
    firstMover = PlayerColor::WHITE;

    net = nullptr;
    isNetworkGame = false;

    //pMusicThread = new QThread(this);
    //musicPlayer.moveToThread(pMusicThread);

    //change this URL path
    //musicPlayer.setMedia(QUrl("qrc:/MonkeysSpinningMonkeys.mp3"));
    musicPlayer.setMedia(QUrl("qrc:/CalltoAdventure.mp3"));
    musicPlayer.play();

    app = mainApp;
}

void GuiGameController::setGuiTurnRotation( int quadrantToRotate, int rotationDirection ){
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

void GuiGameController::setWindow(QQuickView* w){
    window = w;

    QObject* object = window -> rootObject();
    QQuickItem* gui = qobject_cast<QQuickItem*>(object);

    connect(gui, SIGNAL( readyToStartOnePersonPlay() ), this, SLOT( startOnePersonPlay() ) );
    connect(gui, SIGNAL( readyToStartTwoPersonPlay() ), this, SLOT( startTwoPersonPlay() ) );
    connect(gui, SIGNAL( sendPlayerName(QVariant) ), this, SLOT(setPlayerName(QVariant) ) );
    connect(gui, SIGNAL( enterNetworkLobby() ), this, SLOT( enterNetworkLobby()) );
    connect(gui, SIGNAL( changeSoundState() ), this, SLOT( togglePlayback() ) );
    connect(gui, SIGNAL( changeGuiPlayerColor( int )), this, SLOT( setGuiPlayerColor( int ) ) );
    connect(gui, SIGNAL( readyToExitGame() ), this, SLOT( exitGame() ) );
    connect(gui, SIGNAL( backToMainMenu() ), this, SLOT(backToMainMenu()) );

}

void GuiGameController::setPlayerName(QVariant name){

    guiPlayerName = name.toString();

    assert( net != nullptr );
    net -> setNetworkPlayerName(name);

}

//must be called after setWindow
void GuiGameController::setNetworkInterface(NetworkInterface* ni){
    net = ni;

    assert( window != nullptr );
    QObject* object = window -> rootObject();
    QQuickItem* gui = qobject_cast<QQuickItem*>(object);

    //gameController -> network
    connect( this, SIGNAL(gameIsOver()), net, SLOT( tellMeGameIsOver()) );

    //network -> GUI
    connect( net, SIGNAL(challengeReceived(QVariant, QVariant) ), gui, SIGNAL(challengeReceivedFromNetwork(QVariant, QVariant)) );
    connect( net, SIGNAL(challengeResponseReceived(bool)), this, SLOT(challengeResponseReceivedFromNetwork(bool)) );
    connect( net, SIGNAL(networkTurnReceived(int,int,int,int) ), this, SLOT(networkTurnReceivedFromNetwork(int,int,int,int)) );
    connect( this, SIGNAL(challengeAccepted()), gui, SIGNAL(challengeWasAccepted()) );
    connect( this, SIGNAL(challengeDeclined()), gui, SIGNAL(challengeWasDeclined()) );
    connect( net, SIGNAL(playerJoinedNetwork(QVariant, QVariant, int )), gui, SIGNAL(playerEnteredLobby(QVariant, QVariant, int )));
    connect( net, SIGNAL(playerLeftNetwork(int)), gui, SIGNAL(playerLeftLobby(int)));

    //GUI -> network
    connect(gui, SIGNAL(sendThisChallenge(QVariant)), net, SLOT(sendChallenge(QVariant)) );
    connect(gui, SIGNAL(sendThisChallengeResponse(bool)), this, SLOT(forwardChallengeResponse(bool)) );
    connect(gui, SIGNAL(sendThisNetworkMove( int, int, int, int )), net, SLOT(sendGuiTurn( int, int, int, int )) );
}

void GuiGameController::backToMainMenu(){
    qDebug() << "gameController, going back to main menu";
    if( isNetworkGame ){
        isNetworkGame = false;
        net -> leaveLobby();
    }
    else{
        qDebug() << "we weren't just in a network game";
    }

}

//intercepting to get new game ready
void GuiGameController::forwardChallengeResponse(bool accepted){

    if( accepted ){
        //for our program, the challenged player moves first
        firstMover = PlayerColor::WHITE;
        guiPlayerColor = PlayerColor::WHITE;

        startNetworkGame();
    }

    net -> sendChallengeResponse( accepted );
}

void GuiGameController::challengeResponseReceivedFromNetwork(bool challengeWasAccepted){

    qDebug() << "challengeWasAccepted = " << (challengeWasAccepted?"true":"false");

    //start a new game according to parameters
    if( challengeWasAccepted ){
        startNetworkGame();

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



    //network opponent is always BLACK to the game core
    registerOpponentsTurnWithBoard( Turn(quadrantIndex, pieceIndex, quadrantToRotate, rotationDirection, PlayerColor::BLACK ) );

    if( isGameOver() ){
         emit gameIsOver();
    }
    else{
        emit readyForGuiMove();
    }

}


void GuiGameController::startOnePersonPlay() {

    GameCore::startNewGame();

    qGuiTurn.setPieceColor( guiPlayerColor );

    if( guiPlayerColor != firstMover ){

        registerOpponentsTurnWithBoard ( player2 -> getMove( copyCurrentBoard() ) );
        emit readyForGuiMove();
    }

    //default to gui move
    emit readyForGuiMove();


}

void GuiGameController::startTwoPersonPlay() {
    GameCore::startNewGame();

}

void GuiGameController::enterNetworkLobby() {
    qDebug() << "Entering network lobby...";
    isNetworkGame = true;
    net -> enterLobby();
}

void GuiGameController::startNetworkGame() {

    GameCore::startNewGame();

    qOpponentsLastTurn.clear();

    qGuiTurn.setPieceColor( PlayerColor::WHITE );

    if( guiPlayerColor == firstMover ){
        emit readyForGuiMove();
    }
    else{

        //TODO: put this functionality into the AI game too, so we can show a
        //"waiting for move" thing in the GUI
        emit waitingForOpponentsMove();
    }

}



void GuiGameController::togglePlayback(){
    if (musicPlayer.mediaStatus() == QMediaPlayer::NoMedia)
        //error, there is no file set in the player
        ;
    else if (musicPlayer.state() == QMediaPlayer::PlayingState)
        musicPlayer.pause();
    else
        musicPlayer.play();
}

void GuiGameController::setGuiPlayerColor( int menuSelectedColor ){
        guiPlayerColor = static_cast<PlayerColor>(menuSelectedColor);
        if(menuSelectedColor == 0)
        {
           player2 -> setColor(PlayerColor::BLACK);
        }
        else if (menuSelectedColor == 1)
        {
            player2 -> setColor(PlayerColor::WHITE);
        }
}

void GuiGameController::exitGame() {

    app->exit();
}

void GuiGameController::setPlayer2( Player* p ){
    player2 = p;
    player2 -> setColor(PlayerColor::WHITE);
}

//this function oversees the sequence of gameplay
void GuiGameController::registerGuiTurnWithBoard(){

    assert( ! qGuiTurn.isEmpty() );

    try{
        registerTurnWithBoard( qGuiTurn );
    }
    catch(InvalidMoveException){
        emit badMoveFromGui();
        qDebug() << "BAD MOVE FROM GUI";
        throw;
    }

    if( isGameOver() && !isNetworkGame ){
         emit gameIsOver();
     }
     else{

        //print to debug before opponent move
#if PENTAGO_RELEASE == false
        copyCurrentBoard().print();
#endif

        //connected to slot Player::chooseMove(Turn)
        //player2 -> chooseMove( guiPlayersMove );

        //network moves are registered elsewhere.
        if( !isNetworkGame ){
            try{
                registerOpponentsTurnWithBoard( player2 -> getMove( copyCurrentBoard() ) );
            }
            catch(InvalidMoveException){
                qDebug() << "BAD MOVE FROM OPPONENT";
                throw;
            }

            if( isGameOver() ){
                 emit gameIsOver();
            }



 //print to debug after opponent move
#if PENTAGO_RELEASE == false
        copyCurrentBoard().print();
#endif

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

//TODO: I think we may need to change this to setWhetherGuiMovesFirst or something,
//because the GUI colors should be decoupled from the gameController
void GuiGameController::setFirstMovingPlayerColor( PlayerColor playerToMoveFirst ){
    firstMover = playerToMoveFirst;
}

void GuiGameController::registerOpponentsTurnWithBoard(Turn opponentsMove ) {
    //this will only be called by a non-gui player

    //qDebug() << "registering oppenents turn with board";

    GameCore::registerTurnWithBoard(opponentsMove);

    //making sure that this only gets called with the opponents move
    if( !PENTAGO_RELEASE && opponentsMove.getPieceColor() == guiPlayerColor ){
        assert(false);
    }

    if( opponentsMove.getQuadrantToRotate() == DONT_ROTATE_CODE ){
        //OPPONENT WON BECAUSE HE SENT A TURN WITHOUT A ROTATION
        emit gameIsOver();

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
