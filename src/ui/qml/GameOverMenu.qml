import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

GenericPopup {
    id: gameOverMenu
    z: 200

    message: "Draw!";
    hideButton2: true
    button1Text: "Main Menu"
    anchors.verticalCenterOffset: -30 - (height/2) - _QUADRANT_WIDTH

    onButton1Clicked:{
        gameOverMenu.state = "INVISIBLE";
        startMenu.state = "VISIBLE"
        clearPauseOpacity();
        backToMainMenu();
    }

    QmlTimer{
        duration: _OPPONENT_START_ROTATION_DELAY + _ROTATION_ANIMATION_DURATION
        id: gameOverTimeout
        onTriggered:{
            gameOverMenu.state = "VISIBLE";
            lockBoardPieces()
            lockQuadrantRotation()
            pauseOpacity();
            menuIsShowing = true;
        }
    }

    Connections{
        target: gameController
        onGameIsOver:{

            var winner = gameController.getWinner();

            switch( parseInt(winner) ){
                //in each case change gameOverMenu.winText
            case -1:
                gameOverMenu.message = "Draw!"
                break;
            case 0:
                if( guiPlayerIsWhite ){
                    gameOverMenu.state = "VISIBLE";
                }
                else{
                    gameOverTimeout.startTimer();
                }

                gameOverMenu.message ="Green Wins!";
                break;
            case 1:
                if( !guiPlayerIsWhite ){
                    gameOverMenu.state = "VISIBLE";
                }
                else{
                    gameOverTimeout.startTimer();
                }
                gameOverMenu.message = "Purple Wins!";
                break;
            }
        }

    }



}
