import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    id: gameScreen
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    color: "#343434"
    opacity: 1
    z: 0

    property int _MIDDLE_TUBE_WIDTH: 56
    SoundEffect {
            id: playSound
            source: "ButtonClick2.wav"
    }
        
    Oven{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.leftMargin: -75
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -100
        z: 35
    }

        
    Image {
        id: gameScreen_background
        width: parent.width; height: parent.height
        anchors.centerIn: gameScreen
        source: "game-background.png"
        fillMode: Image.PreserveAspectFit
        z: 0
        visible: true
    }



    GumdropKnob {
        id: gumdrop_knob
    }

    Rectangle {
        id: left_can_arm
        width: 150; height: 50; z: 1
        color: "black"

        anchors.top: gameScreen.top
        anchors.topMargin: gameScreen.height/2 + left_can_arm.height
        anchors.left: gameScreen.left
        anchors.leftMargin: -20
    }

    Rectangle {
        id: claw_width_bar
        width: gameScreen.width * 1.7; height: 10; z: 1
        anchors.top: gameScreen.top
        anchors.topMargin: 10
        anchors.left: gameScreen.left
        color: "grey"
    }

    Image {
        id: left_can_back
        width: 152; height: 256; z: 2
        source: "can-back-rusty.png"
        scale: 0.65
        fillMode: Image.PreserveAspectFit
        visible: true

        anchors.top: gameScreen.top
        anchors.topMargin: gameScreen.height/2 - left_can_back.height/2 + 60
        anchors.left: gameScreen.left
        anchors.leftMargin: 75
    }



    Image {
        id: left_can_front
        width: 152; height: 256 ; z: pauseOpacity.z - 10
        source: "can-front-rusty.png"
        scale: 0.65
        fillMode: Image.PreserveAspectFit
        visible: true

        anchors.top: gameScreen.top
        anchors.topMargin: gameScreen.height/2 - left_can_front.height/2 + 60
        anchors.left: gameScreen.left
        anchors.leftMargin: 75
    }

    Rectangle {
        id: right_can_arm
        width: 150; height: 50; z: 1
        color: "black"

        anchors.top: gameScreen.top
        anchors.topMargin: gameScreen.height/2 + right_can_arm.height
        anchors.right: gameScreen.right
        anchors.leftMargin: -20
    }

    Image {
        id: right_can_back
        width: 152; height: 256; z: 2
        source: "can-back-rusty.png"
        scale: 0.65
        fillMode: Image.PreserveAspectFit
        visible: true

        anchors.top: gameScreen.top
        anchors.topMargin: gameScreen.height/2 - left_can_back.height/2 + 60
        anchors.right: gameScreen.right
        anchors.rightMargin: 75
    }

    Image {
        id: right_can_front
        width: 152; height: 256; z: pauseOpacity.z - 10
        source: "can-front-rusty.png"
        scale: 0.65
        fillMode: Image.PreserveAspectFit
        visible: true

        anchors.top: gameScreen.top
        anchors.topMargin: gameScreen.height/2 - left_can_front.height/2 + 60
        anchors.right: gameScreen.right
        anchors.rightMargin: 75

        Connections {
            target: page

            onMakeRightCanGoBack:{
                right_can_front.z = 10;
            }
            onResetRightCan:{
                right_can_front.z = pauseOpacity.z - 10;
            }
        }
    }

    Image {
        id: top_tubes
        width: 525; height: 135; z:5
        source: "top_tubes.png"
        fillMode: Image.PreserveAspectFit
        visible: true

        anchors.top: parent.top
        anchors.topMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 - (top_tubes.width/2)

    }


    ConveyorBelt {
        reverseBelt: true
        anchors.right: top_tubes.left
        anchors.rightMargin: -55
        anchors.top: top_tubes.top
        anchors.topMargin: 80
        z:5
    }

    ConveyorBelt {
        reverseBelt: false
        anchors.left: top_tubes.right
        anchors.leftMargin: -55
        anchors.top: top_tubes.top
        anchors.topMargin: 80
        z:5
    }

    Rectangle {
        id: middle_tube
        width: _MIDDLE_TUBE_WIDTH
        height: parent.height - 140
        color: "grey"
        opacity: 0.5
        z:5

        anchors.top: top_tubes.bottom
        anchors.topMargin: - 20
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 - (middle_tube.width/2)
    }

    /*
    Image {
        id: hg_in_bucket
        width: 250; height: 215
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: (parent.height/2) - 75
        source: "hg-bucket.png"
        fillMode: Image.PreserveAspectFit
        z: 5
    }
    */

    LeftAnimationGumdrop {
        startDelay: 1989
        runAtStart: true
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 1000
        intensityGroup: 2
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 2385
        intensityGroup: 2
        z: 2
    }


    LeftAnimationGumdrop {
        startDelay: 2785
        intensityGroup: 3
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 3799
        intensityGroup: 3
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 3902
        intensityGroup: 3
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 4007
        intensityGroup: 3
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 4191
        intensityGroup: 4
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 4335
        intensityGroup: 4
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 4535
        intensityGroup: 4
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 4739
        intensityGroup: 4
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 4809
        intensityGroup: 4
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 5001
        intensityGroup: 4
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 5943
        intensityGroup: 4
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 7215
        intensityGroup: 4
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 7922
        intensityGroup: 5
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 8812
        intensityGroup: 5
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 9532
        intensityGroup: 5
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 10954
        intensityGroup: 5
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 11911
        intensityGroup: 5
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 13001
        intensityGroup: 5
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 20001
        intensityGroup: 5
        z: 2
        isStrayPiece: true
    }

    //--------------------

    LeftAnimationGumdrop {
        startDelay: 8943
        intensityGroup: 5
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 3415
        intensityGroup: 5
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 7922
        intensityGroup: 5
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 1412
        intensityGroup: 5
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 18532
        intensityGroup: 5
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 67654
        intensityGroup: 5
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 89911
        intensityGroup: 5
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 14401
        intensityGroup: 5
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 29001
        intensityGroup: 5
        z: 2
        isStrayPiece: true
    }

    //--------------------
    RightAnimationGumdrop {
        startDelay: 1000
        runAtStart: true
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 1989
        intensityGroup: 2
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 2385
        intensityGroup: 2
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 2785
        intensityGroup: 3
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 3799
        intensityGroup: 3
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 3902
        intensityGroup: 3
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 4007
        intensityGroup: 3
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 4191
        intensityGroup: 4
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 4335
        intensityGroup: 4
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 4535
        intensityGroup: 4
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 4739
        intensityGroup: 4
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 4809
        intensityGroup: 4
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 5001
        intensityGroup: 4
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 5943
        intensityGroup: 4
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 7215
        intensityGroup: 4
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 7922
        intensityGroup: 4
        z: 2
    }

    //--------------------

    RightAnimationGumdrop {
        startDelay: 8812
        intensityGroup: 5
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 9532
        intensityGroup: 5
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 10954
        intensityGroup: 5
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 11911
        intensityGroup: 5
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 13001
        intensityGroup: 5
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 24001
        intensityGroup: 5
        z: 3
        isStrayPiece: true
    }

    //--------------------

    RightAnimationGumdrop {
        startDelay: 111112
        intensityGroup: 5
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 19532
        intensityGroup: 5
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 15954
        intensityGroup: 5
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 17911
        intensityGroup: 5
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 14501
        intensityGroup: 5
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 24701
        intensityGroup: 5
        z: 3
        isStrayPiece: true
    }

    RightAnimationGumdrop {
        startDelay: 88112
        intensityGroup: 5
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 9572
        intensityGroup: 5
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 10954
        intensityGroup: 5
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 155911
        intensityGroup: 5
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 16601
        intensityGroup: 5
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 24801
        intensityGroup: 5
        z: 2
        isStrayPiece: true
    }

    GameMenu {
        id: myGameMenu
        state: "INVISIBLE"
        z: 100
    }

    Rectangle {
        id: pauseOpacity
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: "#000000"
        opacity: 0
        visible: false
        z: 85

        MouseArea{
            anchors.fill: parent

            onClicked:{

                resumeGumdropAnimation();
                myGameMenu.state = "INVISIBLE"
                console.log("clicked pauseOpacity");
            }

        }



        Connections{
            target: page
            onPauseOpacity:{
                pauseOpacity.state = "OPAQUE";
            }
            onClearPauseOpacity:{
                pauseOpacity.state = "CLEAR";
            }
        }

        states: [
            State{

                name: "CLEAR"

                PropertyChanges {

                    target: pauseOpacity
                    opacity: 0
                }
                PropertyChanges{
                    target: pauseOpacity
                    visible: false
                }
            },

            State{

                name: "OPAQUE"

                PropertyChanges {

                    target: pauseOpacity
                    opacity: 0.75
                }
                PropertyChanges{
                    target: pauseOpacity
                    visible: true
                }
            }

        ]

        transitions: [
            Transition{
                from: "CLEAR"
                to: "OPAQUE"

                PropertyAnimation{
                    properties: "visible"
                    to: true
                    duration: 0
                }

                NumberAnimation{
                    properties: "opacity"
                    from: 0
                    to: 0.75
                    duration: 300
                }
            },
            Transition{
                from: "OPAQUE"
                to: "CLEAR"
                NumberAnimation{
                    properties: "opacity"
                    from: 0.75
                    to: 0
                    duration: 300

                    onStopped:{
                        pauseOpacity.visible = false;
                    }
                }

                PropertyAnimation{
                    properties: "visible"
                    to: false
                    duration: 300
                }
            }

        ]




    }



    GUIButton {
        source_string: "pause-button.png"
        anchors.top: gameScreen.top
        anchors.left: gameScreen.left
        anchors.topMargin: 15
        anchors.leftMargin: 30
        z: 5

        MouseArea {
            anchors.fill: parent
            onPressed: { playSound.play() }
            onClicked: {
            	myGameMenu.state = "VISIBLE"
            	pauseGumdropAnimation();
	    }
        }
    }
}
