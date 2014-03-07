import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: gameOverMenu
    //adjust these how you want, it doesn't really matter
    width: 500
    height: 500
    z: 100

    property bool isVisible: false
    visible: isVisible
    property string winText: "DRAW";

    //text: winText
    Text{
      id: winnerInfo
      text: parent.winText
      anchors.top: gameOverMenu.top
      anchors.horizontalCenter: gameOverMenu.horizontalCenter
      anchors.topMargin: 5

    }


    Button {
        width: 200
        height: 100
        anchors.centerIn: gameOverMenu
        text: "Main Menu"
        onClicked: {
          gameOverMenu.isVisible = false;
          startMenu.state = "VISIBLE"
          backToMainMenu();
        }
    }

    QmlTimer{
        duration: 500
        id: gameOverTimeout
        onTriggered:{
            gameOverMenu.isVisible = true;
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
                winnerInfo.parent.winText ="Tie"
                break;
            case 0:
                if( guiPlayerIsWhite ){
                    gameOverMenu.isVisible = true;
                }
                else{
                    gameOverTimeout.startTimer();
                }

                winnerInfo.parent.winText ="White Wins";
                break;
            case 1:
                if( !guiPlayerIsWhite ){
                    gameOverMenu.isVisible = true;
                }
                else{
                    gameOverTimeout.startTimer();
                }
                winnerInfo.parent.winText ="Black Wins";
                break;
            }
        }

    }



}
