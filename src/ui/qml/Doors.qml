import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {

    id: doorsRectangle
    state: "DEFAULT"

    states:[
        State{
            name: "DEFAULT"
            PropertyChanges{
                target:singlePlayerDoor.anchors
                verticalCenterOffset: 0 - doorsRectangle.height * 2
            }
            PropertyChanges{
                target:versusDoor.anchors
                verticalCenterOffset: 0 - doorsRectangle.height * 2
            }
            PropertyChanges{
                target:networkDoor.anchors
                verticalCenterOffset: 0 - doorsRectangle.height * 2
            }
            PropertyChanges{
                target:defaultDoor.anchors
                verticalCenterOffset: 0
            }
        },
        State{
            name: "SINGLE_PLAYER"
        },
        State{
            name: "VERSUS"
        },
        State{
            name: "NETWORK"
        }
    ]

NumberAnimation {id: defaultDoorUp; target: defaultDoor.anchors; properties: "verticalCenterOffset"; from: 0; to: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: singlePlayerDoorUp; target: singlePlayerDoor.anchors; properties: "verticalCenterOffset"; from: 0; to: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: versusDoorUp; target: versusDoor.anchors; properties: "verticalCenterOffset"; from: 0; to: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: networkDoorUp; target: networkDoor.anchors; properties: "verticalCenterOffset";from: 0; to: 0 - doorsRectangle.height * 2; duration: 1000; }
NumberAnimation {id: defaultDoorDown; target: defaultDoor.anchors; properties: "verticalCenterOffset"; to: 0; from: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: singlePlayerDoorDown; target: singlePlayerDoor.anchors; properties: "verticalCenterOffset"; to: 0; from: 0 - doorsRectangle.height * 2; duration: 1000; }
NumberAnimation {id: versusDoorDown; target: versusDoor.anchors; properties: "verticalCenterOffset"; to: 0; from: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: networkDoorDown; target: networkDoor.anchors; properties: "verticalCenterOffset";to: 0; from: 0 - doorsRectangle.height * 2; duration: 1000; }

transitions:[
    Transition{from: "DEFAULT"; to: "SINGLE_PLAYER"; ScriptAction{script: {
        defaultDoorUp.start();
        singlePlayerDoorDown.start();
    }}},
    Transition{from: "DEFAULT"; to: "VERSUS"; ScriptAction{script: {
        defaultDoorUp.start();
        versusDoorDown.start();
    }}},
    Transition{from: "DEFAULT"; to: "NETWORK"; ScriptAction{script: {
        defaultDoorUp.start();
        networkDoorDown.start();
    }}},
    Transition{from: "SINGLE_PLAYER"; to: "VERSUS"; ScriptAction{script: {
        singlePlayerDoorUp.start();
        versusDoorDown.start();
    }}},
    Transition{from: "SINGLE_PLAYER"; to: "NETWORK"; ScriptAction{script: {
        singlePlayerDoorUp.start();
        networkDoorDown.start();
    }}},
    Transition{from: "VERSUS"; to: "SINGLE_PLAYER"; ScriptAction{script: {
        versusDoorUp.start();
        singlePlayerDoorDown.start();
    }}},
    Transition{from: "VERSUS"; to: "NETWORK"; ScriptAction{script: {
        versusDoorUp.start();
        networkDoorDown.start();
    }}},
    Transition{from: "NETWORK"; to: "VERSUS"; ScriptAction{script: {
        networkDoorUp.start();
        versusDoorDown.start();
    }}},
    Transition{from: "NETWORK"; to: "SINGLE_PLAYER"; ScriptAction{script: {
        networkDoorUp.start();
        singlePlayerDoorDown.start();
    }}}
]





    Rectangle{
        id: defaultDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        color: "#123456"
    }

    Rectangle {
        id: singlePlayerDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0 - doorsRectangle.height * 2
    }

    Rectangle {
        id: versusDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0 - doorsRectangle.height * 2
    }

    Rectangle {
        id: networkDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0 - doorsRectangle.height * 2
    }

    //------singlePlayerDoor Selectors-----------------------------------------

    CharacterSelector{
        id: singlePlayerCharacterSelector
        anchors.top: singlePlayerDoor.top
        anchors.topMargin: -50
        anchors.horizontalCenter: singlePlayerDoor.horizontalCenter
    }

    GumdropSelector {
        id: singlePlayerGumdropSelector
        anchors.top: singlePlayerCharacterSelector.bottom
        anchors.topMargin: -150
        anchors.horizontalCenter: singlePlayerDoor.horizontalCenter
    }

    DifficultySelector {
        id: difficultySelector
        anchors.top: singlePlayerGumdropSelector.bottom
        anchors.topMargin: -150
        anchors.horizontalCenter: singlePlayerDoor.horizontalCenter
    }

    //------versusDoor Selectors-----------------------------------------------

    CharacterSelector{
        id: pvpPlayer1CharacterSelector
        anchors.top: versusDoor.top
        anchors.topMargin: -50
        anchors.horizontalCenter: versusDoor.horizontalCenter
    }

    CharacterSelector{
        id: pvpPlayer2CharacterSelector
        anchors.top: pvpPlayer1CharacterSelector.bottom
        anchors.topMargin: -75
        anchors.horizontalCenter: versusDoor.horizontalCenter
        character_selector_string: "gretel"
    }

    //------networkDoor TextArea------------------------------------------------

    TextArea{
            id: playerNameBox
            width: 100; height: 25
            text: "enter a name"
            textColor: "#474747"
            anchors.verticalCenter: networkDoor.verticalCenter
            anchors.horizontalCenter: networkDoor.horizontalCenter
    }

    //-------------------------------------------------------------------------

    Rectangle{
        id: singlePlayerStartButton
        width: 200; height: 75
        z: singlePlayerDoor.z + 10
        color: "transparent"

        anchors.bottom: singlePlayerDoor.bottom
        anchors.bottomMargin: 125
        anchors.horizontalCenter: singlePlayerDoor.horizontalCenter

        MouseArea{
            id: startHandle_mouseArea
            anchors.fill: singlePlayerStartButton
            hoverEnabled: true

            onEntered:{
                if(startHandle_mouseArea.containsMouse){
                    startStencil_img.source = "start-stencil-selected.png";
                }
            }
            onExited: { startStencil_img.source = "start-stencil.png"; }
            onPressed:{ if(_SOUND_CHECK_FLAG) tankSound.play() }
            onClicked:{
                    if( !piecesHaveStartedAnimating ){
                        startPieceAnimations();
                        piecesHaveStartedAnimating = true;

                    }

                    sendPlayerName( "TODO: FIX MEEEE" /*playerNameBox.text*/ );
                    startMenu.state = "INVISIBLE"
                    isNetworkGame = false;
                    clearBoard();

                var menuSelectedColor;
                if(singlePlayerGumdropSelector.gumdrop_selector_string == "teal")
                {
                    guiPlayerIsWhite = true;
                    menuSelectedColor = 0;

                }
                else if(singlePlayerGumdropSelector.gumdrop_selector_string == "purp")
                {
                    guiPlayerIsWhite = false;
                    menuSelectedColor = 1;
                }
                else{
                    console.log("logic error with gumdrop selector")
                }

                placeCharacterOnPlatform(singlePlayerCharacterSelector.character_selector_string, singlePlayerGumdropSelector.gumdrop_selector_string );

                if( singlePlayerGumdropSelector.gumdrop_selector_string == "teal" ){
                    placeCharacterOnPlatform("witch", "purple");
                }
                else{
                    placeCharacterOnPlatform("witch", "teal");
                }


                if( !piecesHaveStartedAnimating ){
                    startPieceAnimations();
                    piecesHaveStartedAnimating = true;
                }
                else{
                    resumeGumdropAnimation();
                }

                sendPlayerName( "TODO: FIX MEEEE" /*playerNameBox.text*/ );
                startMenu.state = "INVISIBLE"
                isNetworkGame = false;
                clearBoard();


                if( difficultySelector.difficulty_selector_string == "easy" ){
                    readyToStartOnePersonPlay(1, menuSelectedColor);
                }
                else if( difficultySelector.difficulty_selector_string == "med" ) {
                    readyToStartOnePersonPlay(2, menuSelectedColor);
                }
                else if( difficultySelector.difficulty_selector_string == "hard" ) {
                    readyToStartOnePersonPlay(3, menuSelectedColor);
                }
                else{
                    console.log("logic error with difficulty selector")
                }

            }
        }

        Image{
            id: startHandle
            width: singlePlayerStartButton.width
            height: singlePlayerStartButton.height
            z: singlePlayerStartButton.z + 1
            source: "forkliftMenu-handle.png"
            anchors.centerIn: singlePlayerStartButton
        }

        Image{
            id: startStencil_img
            width: singlePlayerStartButton.width
            height: singlePlayerStartButton.height
            anchors.centerIn: singlePlayerStartButton
            z: startHandle.z + 1
            source: "start-stencil.png"
        }
    }
    Rectangle{
        id: pvpStartButton
        width: 200; height: 75
        z: versusDoor.z + 10
        color: "transparent"

        anchors.bottom: versusDoor.bottom
        anchors.bottomMargin: 125
        anchors.horizontalCenter: versusDoor.horizontalCenter

        MouseArea{
            id: pvpHandle_mouseArea
            anchors.fill: pvpStartButton
            hoverEnabled: true

            onEntered:{
                if(pvpHandle_mouseArea.containsMouse){
                    pvpStencil_img.source = "start-stencil-selected.png";
                }
            }
            onExited: { pvpStencil_img.source = "start-stencil.png"; }
            onPressed:{ if(_SOUND_CHECK_FLAG) tankSound.play() }
            //onClicked://TODO: LOGIC!
        }

        Image{
            id: pvpHandle
            width: pvpStartButton.width
            height: pvpStartButton.height
            z: pvpStartButton.z + 1
            source: "forkliftMenu-handle.png"
            anchors.centerIn: pvpStartButton
        }

        Image{
            id: pvpStencil_img
            width: pvpStartButton.width
            height: pvpStartButton.height
            anchors.centerIn: pvpStartButton
            z: pvpHandle.z + 1
            source: "start-stencil.png"
        }
    }

    Rectangle{
        id: networkingStartButton
        width: 200; height: 75
        z: networkDoor.z + 10
        color: "transparent"

        anchors.bottom: networkDoor.bottom
        anchors.bottomMargin: 125
        anchors.horizontalCenter: networkDoor.horizontalCenter

        MouseArea{
            id: networkingHandle_mouseArea
            anchors.fill: networkingStartButton
            hoverEnabled: true

            onEntered:{
                if(networkingHandle_mouseArea.containsMouse){
                    networkingStencil_img.source = "enter-lobby-stencil-selected.png";
                }
            }
            onExited: { networkingStencil_img.source = "enter-lobby-stencil.png"; }
            onPressed:{ if(_SOUND_CHECK_FLAG) tankSound.play() }
            //onClicked://TODO: LOGIC!
        }

        Image{
            id: netHandle
            width: networkingStartButton.width
            height: networkingStartButton.height
            z: networkingStartButton.z + 1
            source: "forkliftMenu-handle.png"
            anchors.centerIn: networkingStartButton
        }

        Image{
            id: networkingStencil_img
            width: networkingStartButton.width
            height: networkingStartButton.height
            anchors.horizontalCenter: networkingStartButton.horizontalCenter
            anchors.verticalCenter: networkingStartButton.verticalCenter
            anchors.verticalCenterOffset: -5
            z: netHandle.z + 1
            source: "enter-lobby-stencil.png"
        }
    }
}
