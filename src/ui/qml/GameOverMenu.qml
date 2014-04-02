import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

GenericPopup {
    id: gameOverMenu
    z: 200
    width: 1440
    height: 250

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
        property string loser: "NONE"
        onTriggered:{
            killCharacter(loser);
            lockBoardPieces()
            lockQuadrantRotation()
            gameOverMenu.state = "VISIBLE";
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
                    killCharacter(purplePlatformCharacter);
                }
                else{
                    gameOverTimeout.loser = purplePlatformCharacter;
                    gameOverTimeout.startTimer();
                }

                gameOverMenu.message ="Green Wins!";
                break;
            case 1:

                if( !guiPlayerIsWhite ){
                    gameOverMenu.state = "VISIBLE";
                    killCharacter(tealPlatformCharacter);
                }
                else{
                    gameOverTimeout.loser = tealPlatformCharacter;
                    gameOverTimeout.startTimer();
                }
                gameOverMenu.message = "Purple Wins!";
                break;
            }

        }
    }



}
