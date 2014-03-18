import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    id: gameMenu
    anchors.left: parent.left
    width: 250; height: parent.height

    state: "VISIBLE"

    Image {
        width: parent.width; height: parent.height
        source: "ingame-menu.png"
        anchors.centerIn: parent
    }

    states: [
        State{
            name: "INVISIBLE"
            PropertyChanges { target: pauseOpacity; state: "CLEAR" }
            PropertyChanges { target: pentagoBoard; state: "UNLOCKED" }
            PropertyChanges { target: gameMenu; anchors.leftMargin: -width + 25 }
        },
        State{
            name: "VISIBLE"
            PropertyChanges { target: pauseOpacity; state: "OPAQUE" }
            PropertyChanges { target: pentagoBoard; state: "LOCKED" }
            PropertyChanges { target: gameMenu; anchors.leftMargin: 0 }
        }
    ]

    transitions: [
        Transition {
             from: "*"; to: "*"
             NumberAnimation {
                 properties: "leftMargin"
                 easing.type: Easing.InOutQuad;
                 duration: 300
            }
        }
    ]

    GUIButton {
        source_string: "play-button.png"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 15
        anchors.leftMargin: 30
        z: 3

        MouseArea {
            anchors.fill: parent
            onClicked: gameMenu.state = "INVISIBLE"
        }
    }

    GUIButton {
        source_string: "restart-button.png"
        anchors.top: parent.top
        anchors.topMargin: (parent.height - 30)/4
        anchors.left: parent.left
        anchors.leftMargin: 30
        z: 3

        MouseArea {
            anchors.fill: parent

            onClicked: {
                clearBoard();
                gameMenu.state = "INVISIBLE";
                changeGuiPlayerColor( guiPlayerIsWhite? 0 : 1 );
                readyToStartOnePersonPlay();
            }
        }
    }

    GUIButton {
        id: soundButton
        source_string: "sound-button.png"
        anchors.top: parent.top
        anchors.topMargin: (parent.height/2) - 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        z: 3

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (soundButton.source_string === "sound-button.png") {
                    soundButton.source_string = "nosound-button.png"
                } else {
                    soundButton.source_string = "sound-button.png"
                }
                changeSoundState();
            }
        }
    }

    GUIButton {
        source_string: "help-button.png"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ((parent.height - 30)/4) - 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        z: 3
    }

    GUIButton {
        source_string: "back-button.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 15
        anchors.leftMargin: 30
        z: 3

        MouseArea {
            anchors.fill: parent

            onClicked: {

                if( isNetworkGame ){
                    networkQuitConfirmationPopup.state = "VISIBLE";
                }else{
                    gameMenu.state = "INVISIBLE";
                    startMenu.state = "VISIBLE";
                    backToMainMenu();
                }
            }
        }
    }

    GenericPopup{
        id: networkQuitConfirmationPopup
        width: 700
        height: 200
        anchors.left: parent.left
        anchors.leftMargin: (1440 / 2) - (width/2)
        anchors.verticalCenter: parent.verticalCenter

        message: "Are you sure you want to quit?"
        button2Text: "Quit"
        button1Text: "Cancel"

        onButton1Clicked: {
            gameMenu.state = "INVISIBLE";
            networkQuitConfirmationPopup.state = "INVISIBLE";
        }

        onButton2Clicked: {
            gameMenu.state = "INVISIBLE";
            networkQuitConfirmationPopup.state = "INVISIBLE";
            startMenu.state = "VISIBLE";
            backToMainMenu();
        }

    }

    /*
    Rectangle{
        //make pretty
        id: networkQuitConfirmationPopup
        width: 700
        height: 200
        anchors.left: parent.left
        anchors.leftMargin: (1440 / 2) - (width/2)
        anchors.verticalCenter: parent.verticalCenter

        Text{
            anchors.left: parent.left
            text: "Are you sure you want to quit?"
        }
        state: "INVISIBLE"
        states:[
            State{
                name: "INVISIBLE"
                PropertyChanges {
                    target: networkQuitConfirmationPopup
                    visible: false
                }
            },
            State{
                name: "VISIBLE"
                PropertyChanges {
                    target: networkQuitConfirmationPopup
                    visible: true
                }
            }
        ]

        Button {
            width: 100
            height: 50
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            text: "Leave game"

            onClicked: {
                gameMenu.state = "INVISIBLE";
                networkQuitConfirmationPopup.state = "INVISIBLE";
                startMenu.state = "VISIBLE";
                backToMainMenu();
            }
        }

        Button {
            width: 100
            height: 50
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 120
            text: "Cancel"

            onClicked: {
                networkQuitConfirmationPopup.state = "INVISIBLE";
                gameMenu.state = "INVISIBLE";
            }
        }

    }*/
}
