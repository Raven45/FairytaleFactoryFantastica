import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {

    id: startMenu
    width: parent.width
    height: parent.height
    z: 100
    color: "#00FFFF"
    visible: false

    state: "INVISIBLE"

    Image {
        id: main_background
        width: 1440; height: 900; z: 0
        anchors.centerIn: parent
        source: "main-menu-background.png"
        fillMode: Image.PreserveAspectFit
    }

    Smoke {
        id: startMenu_smoke1
        x: 1210
        y: 210
    }

    Smoke {
        id: startMenu_smoke2
        x: 1340
        y: 210
    }

    Witch {
        id: startMenu_witch
    }

    states: [
        State{
            name: "VISIBLE"
            PropertyChanges { target: startMenu_smoke1; state: "ON" }
            PropertyChanges { target: startMenu_smoke2; state: "ON" }
            PropertyChanges { target: startMenu_witch;  state: "ON" }
            PropertyChanges { target: startMenu; visible: true }
        },
        State{
            name: "INVISIBLE"
            PropertyChanges { target: startMenu_smoke1; state: "OFF" }
            PropertyChanges { target: startMenu_smoke2; state: "OFF" }
            PropertyChanges { target: startMenu_witch;  state: "OFF" }
            PropertyChanges { target: startMenu; visible: false }
        }

    ]

    TextArea{
        id: playerNameBox
        width: 100
        height: 25
        text: "enter a name"
        anchors.top: parent.top
        anchors.topMargin: parent.height/2 + 135
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 + 90
    }

    GUIButton {
        id: startMenu_startOnePlayer
        source_string: "singleplayer-button.png"
        anchors.top: parent.top
        anchors.topMargin: parent.height/2
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 - 150
        z: 3

        MouseArea {
            anchors.fill: parent

            onClicked: {
                sendPlayerName( playerNameBox.text );
                startMenu.state = "INVISIBLE"
                pentagoBoard.state = "UNLOCKED";
                clearBoard();
                readyToStartOnePersonPlay();
            }
        }
    }

    GUIButton {
        id: startMenu_startNetworkPlay
        source_string: "network-button.png"
        anchors.top: parent.top
        anchors.topMargin: parent.height/2 + 100
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2
        z: 3

        MouseArea {
            anchors.fill: parent

            onClicked: {
                sendPlayerName( playerNameBox.text );
                networkLobby.state ="VISIBLE"
                startMenu.state = "INVISIBLE"
               // pentagoBoard.state = "UNLOCKED";
                clearBoard();
                enterNetworkLobby();
            }
        }
    }

    GUIButton {

        property int buttonColor

        id: colorSelection
        source_string: "purp-button.png"
        anchors.top: parent.top
        anchors.topMargin: parent.height/2
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2
        z: 3

        state: "BLACK"
        buttonColor: 1

        states: [
            State{
                name: "WHITE"
                PropertyChanges{ target: colorSelection; buttonColor: 0 }
            },
            State{
                name: "BLACK"
                PropertyChanges{ target: colorSelection; buttonColor: 1 }
            }
        ]

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(colorSelection.state == "BLACK")
                {
                    colorSelection.source_string = "teal-button.png"
                    colorSelection.state = "WHITE"
                    page.guiPlayerIsWhite = true;
                    changeGuiPlayerColor(colorSelection.buttonColor);
                }
                else
                {
                    colorSelection.source_string = "purp-button.png"
                    colorSelection.state = "BLACK"
                    page.guiPlayerIsWhite = false;
                    changeGuiPlayerColor(colorSelection.buttonColor);
                }
            }
        }
    }

    GUIButton {
        id: startMenu_soundButton
        source_string: "sound-button.png"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ((parent.height - 30)/4) - 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        z: 3

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (startMenu_soundButton.source_string === "sound-button.png") {
                    startMenu_soundButton.source_string = "nosound-button.png"
                } else {
                    startMenu_soundButton.source_string = "sound-button.png"
                }
                changeSoundState();
            }
        }
    }

    GUIButton {
        id: startMenu_leaveGame
        source_string: "leave-button.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 15
        anchors.leftMargin: 30
        z: 3

        MouseArea {
            anchors.fill: parent

            onClicked: {
                readyToExitGame()
            }
        }
    }

}
