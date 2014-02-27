import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

//import GUIPlayer 1.0

Rectangle {
    id: page
    width: parent.width
    height: parent.height
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
    property int _OPPONENT_START_ROTATION_DELAY: 600


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

    StartMenu{
        id:startMenu
        anchors.centerIn: parent
    }
    GameOverMenu {
          id: gameOverMenu
          anchors.centerIn: page
  }
    Board{
        id: pentagoBoard
        anchors.top: page.top
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
