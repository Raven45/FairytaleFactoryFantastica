import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtMultimedia 5.0

Rectangle {
    id: forkliftMenu
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
            StateChangeScript{ name: "playTankSound"; script: if(_SOUND_CHECK_FLAG) tankSound.play(); }
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

    SoundEffect {
        id: tankSound
        source: "tank.wav"
    }

    SoundEffect {
        id: slidingSound
        source: "sliding-sound.wav"
    }

    property int _FORKLIFT_MENU_DOORS_TOP_MARGIN: 100

    Doors{
        id: doors
        z: brickWall + 5
        width: 700;
        height: 800;
        color: "#b4b4b4"
        anchors.top: forkliftMenu.top
        anchors.topMargin: _FORKLIFT_MENU_DOORS_TOP_MARGIN
        anchors.right: forkliftMenu.right
        anchors.rightMargin: 51

        //source: "loading-bay-door.png"
        //width: 1260; //height: loadingBayDoor.width;
        //fillMode: Image.PreserveAspectFit
    }


    Image{
        anchors.fill: parent
        id: brickWall
        source: "LoadingDockWithDoor.png"
        z: 5
    }

    ParallelAnimation{
        id: moveForklift

        NumberAnimation{
            id: moveForkliftFromLeft
            target: forklift.anchors
            properties: "leftMargin"
            duration: 1500
            from: -700
            to: -175
        }
        RotationAnimation{
            id: rotateFrontTire
            target: frontTire
            duration: 1500
            direction: RotationAnimation.Clockwise
            from: 0
            to: 200
        }
        RotationAnimation{
            id: rotateRearTire
            target: rearTire
            duration: 1500
            direction: RotationAnimation.Clockwise
            from: 0
            to: 200
        }

        onStopped:{
            if(tankSound.playing) {
                tankSound.stop();
            }
        }
    }

    Rectangle {
        id: forklift
        y: 248
        color: "transparent"
        anchors.bottomMargin: -48
        anchors.leftMargin: 8
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 700
        height: 700
        scale: 0.75
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
            z: 3
            source: "WideCardboardBox.png"

            Image {
                id: startMenu_startOnePlayer
                source: source_string

                anchors.left: box1.left
                anchors.leftMargin: 15
                anchors.top: box1.top
                anchors.topMargin: 85

                width: 375; height: 375; scale: 1
                z: box1.z + 1

                property string source_string: "single-player-stencil.png"

                MouseArea {
                    id: singlePlayer_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        if( singlePlayer_mouseArea.containsMouse && startMenu_startOnePlayer.source_string === "single-player-stencil.png"){
                            startMenu_startOnePlayer.source_string = "single-player-stencil-selected.png";
                        }
                    }
                    onExited: {
                        if( startMenu_startOnePlayer.source_string === "single-player-stencil-selected.png"){
                            if(startOnePlayer_currently_selected == false){
                                startMenu_startOnePlayer.source_string = "single-player-stencil.png";
                            }
                        }
                    }
                    onPressed: {
                        startOnePlayer_currently_selected = true;
                        if(net_currently_selected == true) {
                            net_currently_selected = false;
                            startMenu_startNetwork.net_source_string = "network-game-stencil.png";
                        }
                        if(pvp_currently_selected == true) {
                            pvp_currently_selected = false;
                            startMenu_startPlayerVsPlayer.pvp_source_string = "player-vs-player-stencil.png";
                        }
                        if(_SOUND_CHECK_FLAG) slidingSound.play();
                    }
                    onClicked: {
                        doors.state = "SINGLE_PLAYER";
                        startMenu_startOnePlayer.source_string = "single-player-stencil-selected.png";
                    }
                }
            }

            /*
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

                        sendPlayerName( "TODO: FIX MEEEE" //playerNameBox.text );
                        startMenu.state = "INVISIBLE"
                        isNetworkGame = false;
                        clearBoard();
                        readyToStartOnePersonPlay();
                    }
                }
            }
            */

            /*GUIButton {

                property int buttonColor

                id: colorSelection
                source_string: "purp-button.png"
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 75
                z: startMenu_startOnePlayer.z + 1

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
            }*/

        }

        Image {
            id: box2
            x: 642
            y: -74
            source: "WideCardboardBox.png"
            z: box1.z - 1

            Image {
                id: startMenu_startPlayerVsPlayer
                source: pvp_source_string
                anchors.left: box2.left
                anchors.leftMargin: 15
                anchors.top: box2.top
                anchors.topMargin: 85
                width: 375; height: 375; scale: 1
                z: box2.z + 1


                property string pvp_source_string: "player-vs-player-stencil.png"

                MouseArea {
                    id: pvp_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        if( pvp_mouseArea.containsMouse && startMenu_startPlayerVsPlayer.pvp_source_string === "player-vs-player-stencil.png"){
                            startMenu_startPlayerVsPlayer.pvp_source_string = "player-vs-player-stencil-selected.png";
                        }
                    }

                    onExited: {
                        if( startMenu_startPlayerVsPlayer.pvp_source_string === "player-vs-player-stencil-selected.png"){
                            if(pvp_currently_selected == false){
                                startMenu_startPlayerVsPlayer.pvp_source_string = "player-vs-player-stencil.png";
                            }
                        }
                    }
                    onPressed: {
                        pvp_currently_selected = true;
                        if(net_currently_selected == true) {
                            net_currently_selected = false;
                            startMenu_startNetwork.net_source_string = "network-game-stencil.png";
                        }
                        if(startOnePlayer_currently_selected == true) {
                            startOnePlayer_currently_selected = false;
                            startMenu_startOnePlayer.source_string = "single-player-stencil.png";
                        }
                        if(_SOUND_CHECK_FLAG) slidingSound.play();
                    }
                    onClicked: {
                        doors.state = "VERSUS"
                        startMenu_startPlayerVsPlayer.pvp_source_string = "player-vs-player-stencil-selected.png";
                    }
                }
            }
        }

        Image {
            id: box3
            x: 616
            y: 186
            source: "WideCardboardBox.png"
            z: box2.z - 1

            Image {
                id: startMenu_startNetwork
                source: net_source_string
                anchors.left: box3.left
                anchors.leftMargin: 15
                anchors.top: box3.top
                anchors.topMargin: 85
                width: 375; height: 375; scale: 1
                z: box3.z + 1

                property string net_source_string: "network-game-stencil.png"

                MouseArea {
                    id: network_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        if( network_mouseArea.containsMouse && startMenu_startNetwork.net_source_string === "network-game-stencil.png"){
                            startMenu_startNetwork.net_source_string = "network-game-stencil-selected.png";
                        }
                    }

                    onExited: {
                        if( startMenu_startNetwork.net_source_string === "network-game-stencil-selected.png"){
                            if( net_currently_selected == false) {
                                startMenu_startNetwork.net_source_string = "network-game-stencil.png";
                            }
                        }
                    }
                    onPressed: {
                        net_currently_selected = true;
                        if(pvp_currently_selected == true) {
                            pvp_currently_selected = false;
                            startMenu_startPlayerVsPlayer.pvp_source_string = "player-vs-player-stencil.png";
                        }
                        if(startOnePlayer_currently_selected == true) {
                            startOnePlayer_currently_selected = false;
                            startMenu_startOnePlayer.source_string = "single-player-stencil.png";
                        }
                        if(_SOUND_CHECK_FLAG) slidingSound.play()
                    }
                    onClicked: {
                        /*if( !piecesHaveStartedAnimating ){
                            startPieceAnimations();
                            piecesHaveStartedAnimating = true;

                        }*/

                        //sendPlayerName( "TODO: FIX MEEEE" /*playerNameBox.text*/ );
                       // networkLobby.state ="VISIBLE"
                        //isNetworkGame = true;
                        //clearBoard();
                        //enterNetworkLobby();

                        doors.state = "NETWORK";
                        startMenu_startNetwork.net_source_string = "network-game-stencil-selected.png";
                    }
                }
            }

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
}

