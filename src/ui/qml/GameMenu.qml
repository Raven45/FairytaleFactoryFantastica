import QtQuick 2.0
import QtQuick.Controls 1.0
import QtMultimedia 5.0

Rectangle {
    id: gameMenu
    anchors.left: parent.left
    width: 250; height: parent.height

    state: "VISIBLE"

    SoundEffect {
        id: playSound
        source: "ButtonClick2.wav"
    }

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
        },
        State{
            name:"MINIMIZE" //for help screen
            PropertyChanges { target: pauseOpacity; state: "OPAQUE" }
            PropertyChanges { target: pentagoBoard; state: "LOCKED" }
            PropertyChanges { target: gameMenu; anchors.leftMargin: -width + 25 }
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
        stencil_string: "blue-resume-stencil.png"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 15
        anchors.leftMargin: 30
        z: parent.z+1

        MouseArea {
            anchors.fill: parent
            onPressed: { if(_SOUND_CHECK_FLAG) playSound.play() }
            onClicked:{
                resumeGumdropAnimation();
                gameMenu.state = "INVISIBLE"
            }
        }
    }

    GUIButton {
        id: soundButton
        source_string: _SOUND_CHECK_FLAG ? "sound-button.png" : "nosound-button.png"
        stencil_string: "blue-sound-stencil.png"
        anchors.top: parent.top
        anchors.topMargin: ((parent.height - 100)/3) + 15
        anchors.left: parent.left
        anchors.leftMargin: 30
        z: parent.z+1

        MouseArea {
            anchors.fill: parent
            onPressed: { if(_SOUND_CHECK_FLAG) playSound.play() }
            onClicked: {
                changeSoundState();
                changeSoundCheckFlag();
            }
        }
    }

    GUIButton {
        id: helpButton
        source_string: "help-button.png"
        stencil_string: "blue-help-stencil.png"
        anchors.top: parent.top
        anchors.topMargin: (2 * ((parent.height - 100) / 3) ) + 15
        anchors.left: parent.left
        anchors.leftMargin: 30
        z: parent.z+1
        MouseArea{
            anchors.fill: parent
            onPressed: { if(_SOUND_CHECK_FLAG) playSound.play() }
            onClicked: {
                gameMenu.state = "INVISIBLE";
                help.state = "SHOW_HELP";
            }
        }
    }

    GUIButton {
        source_string: "exitButton.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 15
        anchors.leftMargin: 30
        z: parent.z+1
        hasInverse: false

        MouseArea {

            hoverEnabled: true

            onEntered: {
                parent.source_string = "exitButtonHover.png"
            }

            onExited: {
                parent.source_string = "exitButton.png"
            }

            anchors.fill: parent
            onPressed: { if(_SOUND_CHECK_FLAG) playSound.play() }
            onClicked: {

                if( isNetworkGame ){
                    networkQuitConfirmationPopup.state = "VISIBLE";
                }
                else if ( isSinglePlayerGame && waitingOnNetworkOrAIMove ){
                    leaveGumdropAnimation();
                    waitingForAISoWeCanExitGame = true;
                    loadingScreen.visible = true;
                }else{
                    gameMenu.state = "INVISIBLE";
                    startMenu.state = "VISIBLE";
                    leaveGumdropAnimation();
                    backToMainMenu();
                }
            }
        }
    }

    Connections{
        target: gameController
        onReadyForGuiMove:{
            if( waitingForAISoWeCanExitGame ){
                waitingForAISoWeCanExitGame = false;
                waitingOnNetworkOrAIMove = false;
                gameMenu.state = "INVISIBLE";
                startMenu.state = "VISIBLE";
                loadingScreen.visible = false;
                backToMainMenu();
            }
        }
    }

    GenericPopup{
        id: networkQuitConfirmationPopup
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
            leaveGumdropAnimation();
            backToMainMenu();
        }

    }
}
