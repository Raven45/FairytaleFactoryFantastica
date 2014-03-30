import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtMultimedia 5.0

Rectangle {
    width: 1440
    height: 900
    color: "black"

    state: "INVISIBLE"

    states: [
        State {
            name: "VISIBLE"
            PropertyChanges { target: menuFade; opacity: 0; visible: true; }
            PropertyChanges { target: startMenu; visible: true }
            StateChangeScript{ name: "moveForklift"; script: moveForklift.start(); }
        },
        State{
            name: "INVISIBLE"
            PropertyChanges { target: menuFade; opacity: 0; visible: false; }
            PropertyChanges { target: startMenu; visible: false }

        }

    ]

    transitions:[
        Transition{
            to: "VISIBLE"

            ScriptAction{
                scriptName: "moveForklift"
            }
        }
    ]

    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: readyToExitGame();
    }

    Image{
        anchors.fill: parent
        id: brickWall
        source: "LoadingDockWithDoor.png"
        z: 5
    }

    NumberAnimation{
        id: moveForklift
        target: forklift.anchors
        properties: "leftMargin"
        duration: 3000
        from: -700
        to: 8

    }

    Rectangle{
        id: forklift
        y: 248
        color: "transparent"
        anchors.bottomMargin: -48
        anchors.leftMargin: 8
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 700
        height: 700
        z: 10

        Image{
            id: forkTruck
            x: 26
            y: 198
            width: 700
            height: 700
            source: "ForkTruck.png"
            anchors.centerIn: parent
        }
        Image{
            id: frontTire
            x: 366
            y: 378
           // x: 378
            //y: 594
            width: 300
            height: 288
            anchors.verticalCenterOffset: 172
            anchors.horizontalCenterOffset: 166
            source: "Tires_Grey.png"
            anchors.centerIn: parent
            z: 13
        }
        Image{
            id: rearTire
            x: -8
            y: 434
            //x: 0
            //y: 640
            width: 224
            height: 224
            anchors.verticalCenterOffset: 196
            anchors.horizontalCenterOffset: -246
            source: "Tires_Grey.png"
            anchors.centerIn: parent
            z: 13
        }

        Image {
            id: forkWitch
            x: 192
            y: 60
            source: "WitchOnForks.png"

            SoundEffect {
                id: witchSound
                source: "witch-laugh.wav"
            }

            MouseArea {
                id: witchMouseArea
                anchors.fill: parent
                onPressed: if(_SOUND_CHECK_FLAG) witchSound.play()
            }
        }

        Image {
            id: fork
            x: 513
            y: 26
            rotation: -3
            source: "Fork.png"
        }



        Image {
            id: box1
            x: 668
            y: -350
            z: 1
            source: "WideCardboardBox.png"

            GUIButton {
                id: startMenu_startOnePlayer
                source_string: "singleplayer-button.png"
                anchors.centerIn: parent
                z: 3

                MouseArea {
                    anchors.fill: parent

                    onClicked: {

                        if( !piecesHaveStartedAnimating ){
                            startPieceAnimations();
                            piecesHaveStartedAnimating = true;

                        }

                        sendPlayerName( "TODO: FIX MEEEE" /*playerNameBox.text*/ );
                        startMenu.state = "INVISIBLE"
                        isNetworkGame = false;
                        clearBoard();
                        readyToStartOnePersonPlay();
                    }
                }
            }

            GUIButton {

                property int buttonColor

                id: colorSelection
                source_string: "purp-button.png"
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 75
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

        }

        Image {
            id: box2
            x: 616
            y: 186
            source: "WideCardboardBox.png"

            GUIButton {
                id: startMenu_startNetworkPlay
                source_string: "network-button.png"
                anchors.centerIn: parent
                z: 3

                MouseArea {
                    anchors.fill: parent

                    onClicked: {

                        if( !piecesHaveStartedAnimating ){
                            startPieceAnimations();
                            piecesHaveStartedAnimating = true;

                        }

                        sendPlayerName( "TODO: FIX MEEEE" /*playerNameBox.text*/ );
                        networkLobby.state ="VISIBLE"
                        isNetworkGame = true;
                        clearBoard();
                        enterNetworkLobby();
                    }
                }
            }
        }

        Image {
            id: box3
            x: 642
            y: -74
            source: "WideCardboardBox.png"
        }



        TextArea {

            /*******TODO: PUT IN POP UP ********/
            visible: false;

            id: playerNameBox
            width: 100
            height: 25
            text: "enter a name"
            anchors.top: parent.top
            anchors.topMargin: parent.height/2 + 135
            anchors.left: parent.left
            anchors.leftMargin: parent.width/2 + 90
        }




    }

    Image {
        id: exitSign
        width: 1056 / 9
        height: 587 / 9
        source: "exitSignDim.png"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 15
        z: 10

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered:{
                exitSign.source = "exitSignLit.png"//"exitSignHover.png"
            }

            onExited:{
                exitSign.source = "exitSignDim.png"//"exitSignHover.png"
            }

            onClicked: {
                readyToExitGame()
            }
        }

    }

    /*Timer{
        id: exitFlickerLongTimer
        interval: 4500
        running: true
        repeat: true

        onTriggered:{
            exitFlickerShortTimer.start()
        }
    }

    Timer{
        id: exitFlickerShortTimer
        interval: 50
        running: false
        property bool isLit: false
        property int flickerCount: 0
        onTriggered:{
            if( flickerCount >= 8 ){
                ++flickerCount;

                if( isLit ){
                    exitSign.source = "exitSignLit.png";
                }
                else{
                    exitSign.source = "exitSignDim.png";
                }

                isLit = !isLit;
                exitFlickerShortTimer.start();
            }
            else{
                flickerCount = 0;
                exitFlickerLongTimer.start();
            }
        }
    }*/






/*


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


