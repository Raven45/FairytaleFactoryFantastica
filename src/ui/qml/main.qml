import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

//import GUIPlayer 1.0

Rectangle {
    id: page

    color: "#333333"

    signal readyToStartOnePersonPlay()
    signal readyToStartTwoPersonPlay()

    signal changeSoundState()
    signal changeGuiPlayerColor(int color)
    signal clickedRandomMove()
    //signal updateCurrentBoard()
    signal readyForRotation()
    signal lockBoardPieces()
    signal unlockBoardPieces()
    signal rotationClicked( int index, int direction )
    signal rotationAnimationFinished(int quadrantRotated, int direction )
    signal placeOpponentsPiece( int qIndex, int pIndex )
    signal clearBoard()
    signal readyToExitGame()
    signal backToMainMenu()
    signal sendPlayerName(var playerName )
    signal readyToOpenClaw(int qIndex, int pIndex, var whichClaw )
    signal showPiece( int qIndex, int pIndex )
    signal turnCogs(int quadrantIndex, int direction )

    //network-related signals
    //TODO: receive challenge response
    signal enterNetworkLobby()
    signal sendThisChallenge( var stringAddressOfPlayerToChallenge )
    signal challengeReceivedFromNetwork( var challengerName, var stringAddressOfPlayerWhoChallenged )
    signal challengeWasAccepted()
    signal challengeWasDeclined()
    signal sendThisChallengeResponse( bool acceptChallenge )
    signal sendThisNetworkMove( int quadrantIndex, int pieceIndex, int quadrantToRotate, int rotationDirection )
    signal playerEnteredLobby( var arrivingPlayerName, var addressOfArrivingPlayer, int playerId )
    signal playerLeftLobby( int playerId )


    property alias main: page
    property bool guiPlayerIsWhite: false
    property string gameMessage
    property bool isFirstMoveOfGame: true
    property int _ROTATION_ANIMATION_DURATION: 400
    property int _OPPONENT_START_ROTATION_DELAY: 600 + 1000 + 34*10 + 800 + 2 //claw animation time...

    property int _QUADRANT_WIDTH: 200
    property int _BOARD_HOLE_WIDTH: 65
    property int _VERTICAL_OUTSIDE: 18
    property int _VERTICAL_CENTER: 228
    property int _HORIZONTAL_TOP: -34
    property int _HORIZONTAL_CENTER: 178
    property int _CLAW_OPEN_DURATION: 350
    property int _CLAW_MOVE_DURATION: 800
    property int _CLAW_X_HOME: pentagoBoard.width/2 - 58
    property int _CLAW_Y_HOME: -300


    onBackToMainMenu:{
        isFirstMoveOfGame = true;
    }

    TextArea{
        text:gameMessage
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5
        height: 20
    }

    QmlTimer{
        id: userMoveTimeout
        duration: _ROTATION_ANIMATION_DURATION
        onTriggered:{
            console.log("7. register move ")
            gameController.registerGuiTurnWithBoard();
        }
    }

    QmlTimer{
        id: opponentsMoveTimeout
        duration: _OPPONENT_START_ROTATION_DELAY
        property int quadrantToRotate
        property int rotationDirection

        onTriggered:{
            console.log("o5: animate opponent rotation." );
            pentagoBoard.playRotateAnimationOnQuadrant(quadrantToRotate, rotationDirection);
            unlockGuiPiecesTimeout.startTimer();

        }
    }

    QmlTimer{
        id: unlockGuiPiecesTimeout
        duration: _ROTATION_ANIMATION_DURATION
        property int quadrantToRotate
        property int rotationDirection

        onTriggered:{
            unlockBoardPieces();

        }
    }

    onClearBoard:{
        unlockBoardPieces();
    }

    Connections{
        onRotationClicked:{

            console.log("4. start rotation animation ");
            pentagoBoard.playRotateAnimationOnQuadrant( index, direction );

            console.log("5. start User timer ");
            userMoveTimeout.startTimer();
        }




    }

    Connections{
        target: gameController
        onReadyForGuiMove:{


            var opponentsMove = gameController.getOpponentsTurn();

            if( !isFirstMoveOfGame ){
                console.log("o1: get opponents move, " + opponentsMove);
                placeOpponentsPiece( opponentsMove[0], opponentsMove[1] );

                if( parseInt(opponentsMove[2]) !== 111 ) //DONT_ROTATE_CODE
                {
                    console.log("o3: tell the timer the rotation" );
                    opponentsMoveTimeout.quadrantToRotate = opponentsMove[2];
                    opponentsMoveTimeout.rotationDirection = opponentsMove[3];
                    console.log("o4: start timer" );
                    opponentsMoveTimeout.startTimer();
                }


            }

            isFirstMoveOfGame = false;


            //need to unlock the gui
        }

    }
    NetworkLobby{
        id:networkLobby
        anchors.centerIn: parent
    }

    SplashScreen {
        id: splash
    }

    StartMenu{
        id:startMenu
        anchors.centerIn: parent
    }
    GameOverMenu {
          id: gameOverMenu
          anchors.centerIn: page
    }
    GameScreen{
        id: gameScreen

        Board{
            id: pentagoBoard
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
