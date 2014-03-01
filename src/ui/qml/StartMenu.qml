import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {

    id: startMenu
    width: parent.width
    height: parent.height
    z: 100
    color: "#00FFFF"

    Image {
        id: main_background
        width: 1440; height: 900; z: 0
        anchors.centerIn: parent
        source: "main-menu-background.png"
        fillMode: Image.PreserveAspectFit
    }

    states: [
        State{
            name: "VISIBLE"
            PropertyChanges {
                target: startMenu
                visible: true
            }

        },
        State{
            name: "INVISIBLE"
            PropertyChanges {
                target: startMenu
                visible: false
            }
        }

    ]

    TextArea{
        id: playerNameBox
        width: 100
        height: 25
        text: "enter a name"
        anchors.left: parent.left
        anchors.leftMargin: 400
        anchors.top: parent.top
        anchors.topMargin: 5
    }

    Button {
        id: startOnePlayer
        width: 100
        height: 50
        anchors.centerIn: parent
        text: "One Player"
        onClicked: {
            sendPlayerName( playerNameBox.text );
            startMenu.state = "INVISIBLE"
            pentagoBoard.state = "UNLOCKED";
            clearBoard();
            readyToStartOnePersonPlay();
        }
    }

    Button {
        id: startTwoPlayer
        width: 100
        height: 50
        anchors.top: startOnePlayer.bottom
        text: "Two Player"
        onClicked: {
            sendPlayerName( playerNameBox.text );
            startMenu.state = "INVISIBLE"
            pentagoBoard.state = "UNLOCKED";
            clearBoard();
            readyToStartTwoPersonPlay();
        }
    }

    Button {
        id: startNetworkPlay
        width: 100
        height: 50
        anchors.top: startTwoPlayer.bottom
       text: "Network Play"
        onClicked: {
            sendPlayerName( playerNameBox.text );
            networkLobby.state ="VISIBLE"
            startMenu.state = "INVISIBLE"
           // pentagoBoard.state = "UNLOCKED";
            clearBoard();
            console.log("network play button clicked!");
            enterNetworkLobby();
        }
    }

    Button {
        id: soundControl
        width: 100
        height: 50
        anchors.top: startNetworkPlay.bottom
        state: "UNPRESSED"
        states: [
            State{
                name: "PRESSED"
                PropertyChanges{
                    target:  soundControl
                    text: "Sound: OFF"
                }
            },
             State{
                 name: "UNPRESSED"
                 PropertyChanges {
                     target: soundControl
                     text: "Sound: ON"
                 }
             }
        ]
        onClicked: {
            if(state == "UNPRESSED")
            {
                soundControl.state = "PRESSED"
            }
            else
            {
                soundControl.state = "UNPRESSED"
            }
            changeSoundState();
        }
    }

    Button {
        property int buttonColor

        id: colorSelection
        width: 100
        height: 50
        anchors.top: soundControl.bottom
        text: "Color Selection"
        state: "BLACK"
        states: [
            State{
                name: "WHITE"
                PropertyChanges{
                    buttonColor: 0
                    target:  colorSelection
                    text: "Color: WHITE"
                }
            },
             State{
                 name: "BLACK"
                 PropertyChanges {
                     buttonColor: 1
                     target: colorSelection
                     text: "Color: BLACK"
                 }
             }
        ]
        onClicked: {
            if(state == "BLACK")
            {
                colorSelection.state = "WHITE"
                page.guiPlayerIsWhite = true;
                changeGuiPlayerColor(buttonColor);
            }
            else
            {
                colorSelection.state = "BLACK"
                page.guiPlayerIsWhite = false;
                changeGuiPlayerColor(buttonColor);
            }
        }
    }

    Button {
        id: exitGame
        width: 100
        height: 50
        anchors.top: colorSelection.bottom
        text: "Exit Game"
        onClicked: {
            readyToExitGame()
        }
    }

}
