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
        width: parent.width; height: parent.height; z: 0
        anchors.centerIn: parent
        source: "HomeMenu.png"
        fillMode: Image.PreserveAspectCrop
    }


    Image{
        id: main_factory
        source: "Factory.png"
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.top: parent.top
        anchors.topMargin: 100
        z: 1
        height: 165
        width: 240
        fillMode: Image.PreserveAspectFit
    }


    Smoke {
        id: startMenu_smoke1
        anchors.bottom: main_factory.top
        anchors.bottomMargin: -47
        anchors.left: main_factory.left
        anchors.leftMargin: 40
    }

    Smoke {
        id: startMenu_smoke2
        anchors.bottom: main_factory.top
        anchors.bottomMargin: -50
        anchors.right: main_factory.right
    }


    Image{
        id: main_gate
        source: "Gate.png"
        anchors.right: parent.right
        anchors.rightMargin: 150
        anchors.top: parent.top
        anchors.topMargin: 20
        z: 10
        height: 512
        width: 692
        fillMode: Image.PreserveAspectFit
    }

    Image{
        id: gate_rDoor
        source: "GatePart2.png"
        anchors.bottom: main_gate.bottom
        anchors.bottomMargin: 20
        anchors.right: main_gate.right
        anchors.rightMargin: 130
        z: 9
        height: 360
        width: 280
        fillMode: Image.PreserveAspectFit
    }

    Image{
        id: gate_lDoor
        source: "GatePart1.png"
        anchors.bottom: main_gate.bottom
        anchors.bottomMargin: 30
        anchors.left: main_gate.left
        anchors.leftMargin: 80
        z: 10
        height: 360
        width: 280
        fillMode: Image.PreserveAspectFit
    }

    Image{
        id: hansel
        source: "Hansel.png"
        anchors.right: gate_lDoor.right
        anchors.rightMargin: 58
        anchors.bottom: gate_lDoor.bottom
        anchors.bottomMargin: -55
        z: 11
        height: 240
        width: 160
        fillMode: Image.PreserveAspectFit

    }


    Image{
        id: gretel
        source: "Gretel.png"
        anchors.left: hansel.right
        anchors.leftMargin: -15
        anchors.top: gate_lDoor.bottom
        anchors.bottomMargin: -60
        z: 11
        height: 240
        width: 160
        fillMode: Image.PreserveAspectFit

    }


    Image{
        id: breadcrumbs
        source: "Bread.png"
        anchors.right: gretel.left
        anchors.rightMargin: -25
        anchors.top: gretel.bottom
        anchors.topMargin: -20
        z: 11
     }


    Image{
        id:  footprints
        source: "FootPrints.png"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        z: 5
    }

    Image{
        id: treeLayer1
        source: "Tree5.png"
        anchors.left: parent.left
        anchors.leftMargin: 2
        anchors.top: parent.top
        anchors.topMargin: 40
        z: 1
    }

/*
    Witch {
        id: startMenu_witch
    }
*/
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
    /*

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

                if( !piecesHaveStartedAnimating ){
                    startPieceAnimations();
                    piecesHaveStartedAnimating = true;

                }

                sendPlayerName( playerNameBox.text );
                startMenu.state = "INVISIBLE"
                isNetworkGame = false;
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

                if( !piecesHaveStartedAnimating ){
                    startPieceAnimations();
                    piecesHaveStartedAnimating = true;

                }

                sendPlayerName( playerNameBox.text );
                networkLobby.state ="VISIBLE"
                isNetworkGame = true;
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
    */

}
