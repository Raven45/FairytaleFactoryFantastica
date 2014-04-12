import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {

    id: doorsRectangle
    color: "transparent"

    FontLoader{ id: stencilFont; source: "STENCIL.TTF" }
    FontLoader{ id: monoSpacedDejaVu; source: "DejaVuSansMono.ttf" }

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
            name: "UP"
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
                verticalCenterOffset: 0 - doorsRectangle.height * 2
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

NumberAnimation {id: defaultDoorUp; alwaysRunToEnd: true; target: defaultDoor.anchors; properties: "verticalCenterOffset"; to: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: singlePlayerDoorUp; alwaysRunToEnd: true;target: singlePlayerDoor.anchors; properties: "verticalCenterOffset"; to: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: versusDoorUp;alwaysRunToEnd: true; target: versusDoor.anchors; properties: "verticalCenterOffset"; to: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: networkDoorUp; alwaysRunToEnd: true;target: networkDoor.anchors; properties: "verticalCenterOffset"; to: 0 - doorsRectangle.height * 2; duration: 1000; }
NumberAnimation {id: defaultDoorDown;alwaysRunToEnd: true; target: defaultDoor.anchors; properties: "verticalCenterOffset"; to: 0; duration: 1000; }
NumberAnimation {id: singlePlayerDoorDown;alwaysRunToEnd: true; target: singlePlayerDoor.anchors; properties: "verticalCenterOffset"; to: 0; duration: 1000; }
NumberAnimation {id: versusDoorDown;alwaysRunToEnd: true; target: versusDoor.anchors; properties: "verticalCenterOffset"; to: 0; duration: 1000; }
NumberAnimation {id: networkDoorDown;alwaysRunToEnd: true; target: networkDoor.anchors; properties: "verticalCenterOffset";to: 0; duration: 1000; }

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
    ,
    Transition{from: "SINGLE_PLAYER"; to: "UP"; ScriptAction{script: {
        singlePlayerDoorUp.start();
    }}},
    Transition{from: "VERSUS"; to: "UP"; ScriptAction{script: {
        versusDoorUp.start();
    }}},
    Transition{from: "NETWORK"; to: "UP"; ScriptAction{script: {
        networkDoorUp.start();
    }}}
]

    Timer{
        id: moveForklift_IntoGameScreen_Timer
        interval: 350
        running: false
        repeat: false
        onTriggered: {
            moveForklift_IntoGameScreen.start();
        }
    }

    function allThatWitch_IntoGameScreen(){
        helpBox_glowEffect.visible = false;
        pulse_helpBox_glowEffect.stop();
        doorsRectangle.state = "UP";
        moveForklift_IntoGameScreen_Timer.start();
    }

    Rectangle{
        id: defaultDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        Image {
            id: defaultPlayerDoor_img
            width: parent.width; height: parent.height
            source: "forkliftDoor2.png"
        }
    }

    Rectangle {
        id: singlePlayerDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0 - doorsRectangle.height * 2

        Image {
            id: singlePlayerDoor_img
            width: parent.width; height: parent.height
            source: "forkliftDoor2.png"
        }
    }

    Rectangle {
        id: versusDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0 - doorsRectangle.height * 2

        Image {
            id: versusPlayerDoor_img
            width: parent.width; height: parent.height
            source: "forkliftDoor2.png"
        }
    }

    Rectangle {
        id: networkDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0 - doorsRectangle.height * 2

        Image {
            id: networkDoor_img
            width: parent.width; height: parent.height
            source: "forkliftDoor2.png"
        }
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
        anchors.topMargin: -25
        anchors.horizontalCenter: versusDoor.horizontalCenter
        overrideDefault: true
        onCharacterChangeClicked:{
            changeCharacter();
            pvpPlayer2CharacterSelector.changeCharacter();
        }

        Rectangle{
            id: p1DropRectangle
            height: 300
            width: 300
            anchors.centerIn: pvpPlayer1CharacterSelector
            rotation: 0
            z: -1
            color: "transparent"
            Image{
                id: topDrop
                source: "teal-gumdrop-centered.png"
                width: 150
                height: 150
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image{
                id: leftDrop
                source: "teal-gumdrop-centered.png"
                width: 150
                height: 150
                anchors.left: parent.left
                rotation: 270
                anchors.verticalCenter: parent.verticalCenter
            }
            Image{
                id: bottomDrop
                source: "teal-gumdrop-centered.png"
                width: 150
                height: 150
                anchors.bottom: parent.bottom
                rotation: 180
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image{
                id: rightDrop
                source: "teal-gumdrop-centered.png"
                width: 150
                height: 150
                anchors.right: parent.right
                rotation: 90
                anchors.verticalCenter: parent.verticalCenter
            }

            NumberAnimation { targets: [topDrop,leftDrop,bottomDrop,rightDrop,p1DropRectangle]; property: "rotation"; from: rotation; to: rotation-360;duration: 6000; easing.type: Easing.Linear;
                running: doorsRectangle.state == "VERSUS" && !forkliftMenuButtonsAreLocked; loops: Animation.Infinite }

        }
    }

    CharacterSelector{
        id: pvpPlayer2CharacterSelector
        anchors.top: pvpPlayer1CharacterSelector.bottom
        anchors.topMargin: -75
        anchors.horizontalCenter: versusDoor.horizontalCenter
        character_selector_string: "gretel"
        overrideDefault: true
        onCharacterChangeClicked:{
            changeCharacter();
            pvpPlayer1CharacterSelector.changeCharacter();
        }

        Rectangle{
            id: p2DropRectangle
            height: 300
            width: 300
            anchors.centerIn: pvpPlayer2CharacterSelector
            rotation: 0
            z: -1
            color: "transparent"
            Image{
                id: topDrop2
                source: "purp-gumdrop-centered.png"
                width: 150
                height: 150
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image{
                id: leftDrop2
                source: "purp-gumdrop-centered.png"
                width: 150
                height: 150
                anchors.left: parent.left
                rotation: 270
                anchors.verticalCenter: parent.verticalCenter
            }
            Image{
                id: bottomDrop2
                source: "purp-gumdrop-centered.png"
                width: 150
                height: 150
                anchors.bottom: parent.bottom
                rotation: 180
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image{
                id: rightDrop2
                source: "purp-gumdrop-centered.png"
                width: 150
                height: 150
                anchors.right: parent.right
                rotation: 90
                anchors.verticalCenter: parent.verticalCenter
            }

            NumberAnimation { targets: [topDrop2,leftDrop2,bottomDrop2,rightDrop2,p2DropRectangle]; property: "rotation"; from: rotation; to: rotation+360;duration: 6000; easing.type: Easing.Linear;
                running: doorsRectangle.state == "VERSUS" && !forkliftMenuButtonsAreLocked; loops: Animation.Infinite }

        }
    }

    //------networkDoor TextArea------------------------------------------------

    //What happens when changed from TextArea to TextInput?
    Text{
        id: networkId_text
        font{ family: stencilFont.name; pointSize: 18 }
        color: "black"
        text: "NETWORK ID"

        width: playerNameBox.width
        height: playerNameBox.height
        anchors.horizontalCenter: networkDoor.horizontalCenter
        anchors.bottom: playerNameBox_rec.top
        anchors.bottomMargin: 10
    }

    Rectangle{
        id: playerNameBox_rec
        width: playerNameBox.width
        height: playerNameBox.height
        anchors.verticalCenter: networkDoor.verticalCenter
        anchors.horizontalCenter: networkDoor.horizontalCenter
        color: "white"
        border.color: "black"

        TextInput{
                id: playerNameBox
                width: 205; height: 25
                anchors.left: playerNameBox_rec.left
                anchors.leftMargin: 2
                anchors.verticalCenter: playerNameBox_rec.verticalCenter
                anchors.verticalCenterOffset: 2
                focus: false
                activeFocusOnPress: false
                font{ family: monoSpacedDejaVu.name; pointSize: 12 }
                text: "Type Your ID Here"
                maximumLength: 19
                color: "#474747"

                selectionColor: "black"
                selectedTextColor: "white"

                MouseArea{
                    id: playerNameBox_mouseArea
                    anchors.fill: playerNameBox
                    onClicked: {
                        playerNameBox.selectAll();
                        if(playerNameBox.text != ""){
                            playerNameBox.text = ""
                        }

                        if(!playerNameBox.activeFocus){
                            playerNameBox.forceActiveFocus();
                        } else {
                            playerNameBox.focus = false;
                        }
                    }
                }

                onAccepted: {
                    if(playerNameBox.text == "" || playerNameBox.text == "Type Your ID Here"){
                        submission_error.visible = true;
                    } else if(submission_error.visible){
                        submission_error.visible = false;
                    }

                    playerNameBox.focus = false;
                    escKeyQuit.focus = true;
                }
        }
    }

    Text {
        id: submission_error
        font.pointSize: 12
        color: "red" //'#6B6B6B'
        text: '(Please submit a valid ID)'

        visible: false

        width: playerNameBox.width
        height: playerNameBox.height
        anchors.horizontalCenter: networkDoor.horizontalCenter
        anchors.top: playerNameBox_rec.bottom
        anchors.topMargin: 5
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
                if(startHandle_mouseArea.containsMouse && !forkliftMenuButtonsAreLocked ){
                    startStencil_img.source = "start-stencil-selected.png";
                }
            }
            onExited: { startStencil_img.source = "start-stencil.png"; }
            onPressed:{ if(_SOUND_CHECK_FLAG && !forkliftMenuButtonsAreLocked ) tankSound.play() }
            onClicked:{

                if( !forkliftMenuButtonsAreLocked ){
                    sendPlayerName( "TODO: DEPRECATED?" );

                    isNetworkGame = false;
                    isVersusGame = false;
                    isSinglePlayerGame = true;

                    var menuSelectedColor;
                    if(singlePlayerGumdropSelector.gumdrop_selector_string == "teal")
                    {
                        networkOrAIIsTeal = false;
                        waitingOnNetworkOrAIMove = false;
                        movingPlayerIsNetworkOrAI = false;
                        menuSelectedColor = 0;

                    }
                    else if(singlePlayerGumdropSelector.gumdrop_selector_string == "purp")
                    {
                        networkOrAIIsTeal = true;
                        movingPlayerIsNetworkOrAI = true;
                        waitingOnNetworkOrAIMove = true;
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

                    leaveForkliftMenuToGameScreen();

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

                    if( networkOrAIIsTeal ){
                        lockBoardPieces();
                    }
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
                if(pvpHandle_mouseArea.containsMouse && !forkliftMenuButtonsAreLocked ){
                    pvpStencil_img.source = "start-stencil-selected.png";
                }
            }
            onExited: { pvpStencil_img.source = "start-stencil.png"; }
            onPressed:{ if(_SOUND_CHECK_FLAG && !forkliftMenuButtonsAreLocked ) tankSound.play() }
            onClicked:{
                if( !forkliftMenuButtonsAreLocked ){
                    //allThatWitch_IntoGameScreen();

                    sendPlayerName( "TODO: DEPRECATED?" );
                    isNetworkGame = false;
                    isVersusGame = true;
                    isSinglePlayerGame = false;

                    placeCharacterOnPlatform(pvpPlayer1CharacterSelector.character_selector_string, "teal" );
                    placeCharacterOnPlatform(pvpPlayer2CharacterSelector.character_selector_string, "purple" );

                    leaveForkliftMenuToGameScreen();
                    readyToStartTwoPersonPlay();
                }
            }
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
                if(networkingHandle_mouseArea.containsMouse && !forkliftMenuButtonsAreLocked ){
                    networkingStencil_img.source = "enter-lobby-stencil-selected.png";
                }
            }
            onExited: { networkingStencil_img.source = "enter-lobby-stencil.png"; }
            onPressed:{
                if(playerNameBox.text === "" || playerNameBox.text == "Type Your ID Here"){
                    submission_error.visible = true;
                } else if(submission_error.visible){
                    submission_error.visible = false;
                }
                if(playerNameBox.activeFocus) playerNameBox.focus = false;

            }
            onClicked: {

                if( !forkliftMenuButtonsAreLocked && !submission_error.visible ){
                    if(_SOUND_CHECK_FLAG && !forkliftMenuButtonsAreLocked ) tankSound.play()
                    escKeyQuit.focus = true;

                    isNetworkGame = true;
                    isVersusGame = false;
                    isSinglePlayerGame = false;

                    sendPlayerName( playerNameBox.text );
                    networkLobby.state ="VISIBLE";
                    forkliftMenuButtonsAreLocked = true;
                    enterNetworkLobby();
                }
            }
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
