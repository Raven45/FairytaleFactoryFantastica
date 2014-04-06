import QtQuick 2.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

Rectangle {
    id: helpScreen

    visible: false
    color:"transparent"
    states: [
        State{
            name: "SHOW_HELP"
            PropertyChanges { target: helpScreen; visible: true }
        },
        State{
            name: "HIDE_HELP"
            PropertyChanges { target: helpScreen; visible: false }
        }
    ]

    MouseArea {
        anchors.fill: parent
        onPressed: { playSound.play() }
        onClicked: {
            help.state = "HIDE_HELP";
        }
    }

    SoundEffect {
            id: leftOrRightSound
            source: "ButtonClick2.wav"
    }

    Image {
        id: step1
        width: 550; height: 550; z: parent.z+1
        anchors.verticalCenterOffset: -25
        visible: true
        source: "step1.png"
        anchors.centerIn: helpScreen
        MouseArea{
            anchors.fill: step1;
            onClicked: {
                step1.visible = false;
                step2.visible = true;
                infoAboutIndex.text = "page 2 of 3"
            }
        }
    }
    Image {
        id: step2
        width: 550; height: 550; z: parent.z+1
        anchors.verticalCenterOffset: -25
        visible: false
        source: "step2.png"
        anchors.centerIn: helpScreen
        MouseArea{
            anchors.fill: step2;
            onClicked: {
                step2.visible = false;
                step3.visible = true;
                infoAboutIndex.text = "page 3 of 3"
            }
        }
    }
    Image {
        id: step3
        width: 550; height: 550; z: parent.z+1
        anchors.verticalCenterOffset: -25
        visible: false
        source: "step3.png"
        anchors.centerIn: helpScreen
        MouseArea{
            anchors.fill: step3;
            onClicked: {
                step3.visible = false;
                step1.visible = true;
                infoAboutIndex.text = "page 1 of 3"
            }
        }
    }

    Text {
        id: infoAboutIndex
        width: 250; height: 100;
        z: parent.z + 1
        text: "page 1 of 3"
        font.pointSize: 24
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "#9DEB9B"
        anchors.centerIn: helpScreen
        anchors.verticalCenterOffset: 300
        visible: true
    }

    function makePage1Visible() {
        step1.visible = true;
        infoAboutIndex.text = "page 1 of 3";
        step1Text.visible = true;
    }
    function makePage1Invisible() {
        step1.visible = false;
        step1Text.visible = false;
    }
    function makePage2Visible() {
        step2.visible = true;
        infoAboutIndex.text = "page 2 of 3";
        step2Text.visible = true;
    }
    function makePage2Invisible() {
        step2.visible = false;
        step2Text.visible = false;
    }
    function makePage3Visible() {
        step3.visible = true;
        infoAboutIndex.text = "page 3 of 3";
        step3Text.visible = true;
    }
    function makePage3Invisible() {
        step3.visible = false;
        step3Text.visible = false;
    }

    Image {
        id: background
        source: "steelplate.jpg"
        visible: true
        z: parent.z - 1
        width: helpScreen.width; height: helpScreen.height;
        anchors.fill: helpScreen
    }

    Text {
        id: step1Text
        color: infoAboutIndex.color
        font.pointSize: 24
        font.bold: true
        z: parent.z + 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: helpScreen.verticalCenter
        anchors.left: helpScreen.left
        anchors.leftMargin: 50
        visible: true
        text: "The Objective:
Place 5 magic gumdrops
in a row in any direction"
    }

    Text{
        id: step2Text
        color: infoAboutIndex.color
        font.pointSize: 24
        font.bold: true
        z: parent.z + 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: helpScreen.verticalCenter
        anchors.left: step2.right
//        anchors.leftMargin: 30
        visible: false
        text: "Click the hole
where you want
to place your piece

Legal moves are
highlighted"
    }

    Text{
        id: step3Text
        color: infoAboutIndex.color
        font.pointSize: 24
        font.bold: true
        z: parent.z + 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: helpScreen.verticalCenter
        anchors.left: helpScreen.left
        anchors.leftMargin: 50
        visible: false
        text: "Select a 90
degree rotation
from one of the 8
rotation buttons

This will turn
the corresponding
gingerbread square"
    }

    Item{
        id: left
        z: parent.z + 1
        anchors.right: infoAboutIndex.left
        anchors.verticalCenter: infoAboutIndex.verticalCenter
        anchors.rightMargin: 20
        width: left_img.width; height: left_img.height

        Glow {
           id: leftHelpSelector_glowEffect
           anchors.fill: left_img
           radius: 8
           samples: 24
           spread: 0.5
           color: "#58d6ff"
           source: left_img
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: left_img
            source: "left-selector.png"
            width: 50; height: 50;
            visible: true

            MouseArea {
                id: leftHelpSelector_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(leftHelpSelector_glowEffect.visible == false && leftHelpSelector_mouseArea.containsMouse){
                        leftHelpSelector_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(leftHelpSelector_glowEffect.visible == true){
                        leftHelpSelector_glowEffect.visible = false;
                    }
                }
                onPressed: { if(_SOUND_CHECK_FLAG) leftOrRightSound.play() }
                onClicked:{
                    if (step1.visible == true){
                        makePage1Invisible();
                        makePage3Visible();
                    }
                    else if (step2.visible == true){
                        makePage2Invisible();
                        makePage1Visible();
                    }
                    else if (step3.visible == true){
                        makePage3Invisible();
                        makePage2Visible();
                    }
                    else{
                        infoAboutIndex.text = "error"
                    }
                }
            }
        }
    }

    Item{
        id: right
        z: parent.z + 1
        anchors.left: infoAboutIndex.right
        anchors.verticalCenter: infoAboutIndex.verticalCenter
        anchors.leftMargin: 20
        width: right_img.width; height: right_img.height

        Glow {
           id: rightHelpSelector_glowEffect
           anchors.fill: right_img
           radius: 8
           samples: 24
           spread: 0.5
           color: "#58d6ff"
           source: right_img
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: right_img
            source: "right-selector.png"
            width: 50; height: 50;
            visible: true

            MouseArea {
                id: rightHelpSelector_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(rightHelpSelector_glowEffect.visible == false && rightHelpSelector_mouseArea.containsMouse){
                        rightHelpSelector_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(rightHelpSelector_glowEffect.visible == true){
                        rightHelpSelector_glowEffect.visible = false;
                    }
                }
                onPressed: { if(_SOUND_CHECK_FLAG) leftOrRightSound.play() }
                onClicked:{
                    if (step1.visible == true){
                        makePage1Invisible();
                        makePage2Visible();
                    }
                    else if (step2.visible == true){
                        makePage2Invisible();
                        makePage3Visible();
                    }
                    else if (step3.visible == true){
                        makePage3Invisible();
                        makePage1Visible();
                    }
                    else{
                        infoAboutIndex.text = "error reading the page"
                    }
                }
            }
        }
    }

    Image {
        id: exitHelp
        source: "exitButton.png"
        width: 100; height: 100;
        z: parent.z + 1
        anchors.left: helpScreen.left
        anchors.leftMargin: 20
        anchors.bottom: helpScreen.bottom
        anchors.bottomMargin: 20
        visible: true
        MouseArea {
            anchors.fill: parent
            onClicked:{
                resumeGumdropAnimation();
                helpScreen.state = "HIDE_HELP"
            }
        }
    }
}
