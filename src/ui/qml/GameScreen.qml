import QtQuick 2.0

Rectangle {
    id: gameScreen
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    color: "#343434"
    opacity: 1
    z: 0

    Image {
        id: gameScreen_background
        width: parent.width; height: parent.height
        anchors.centerIn: gameScreen
        source: "game-background.png"
        fillMode: Image.PreserveAspectFit
        z: 0
        visible: true
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
        width: 56
        height: parent.height - 140
        color: "grey"
        opacity: 0.5
        z:5

        anchors.top: top_tubes.bottom
        anchors.topMargin: - 20
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 - (middle_tube.width/2)
    }


    LeftAnimationGumdrop {
        startDelay: 1000
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 2000
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 2400
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 300
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 9000
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 1234
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 2345
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 3456
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 4576
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 5678
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 6789
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 7890
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 10
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 10000
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 10234
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 5170
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 6111
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 12634
        z: 2
    }

/*
    Image {
        id: small_gumdrop
        width: 100; height: 100; z: 2
        scale: 0.65
        x: parent.width/2 - (small_gumdrop.width/2)
        y: parent.height + small_gumdrop.height
        source: "teal-gumdrop-centered.png"
    }


    SequentialAnimation{
        id: tube_animation
        running: true
        loops: Animation.Infinite

        property int leg1: 1600
        property int leg2: 500
        property int leg3: 900
        property int leg4: 3000
        property int leg5: 1200

        property int endOfConverorBeltX: 172
        property int endOfConverorBeltY: 132

        ParallelAnimation{

            RotationAnimation {
                target: small_gumdrop
                duration: 500
                from: 0
                to: 360
                loops: ( tube_animation.leg1 + tube_animation.leg2 + tube_animation.leg3 ) / duration

            }

            SequentialAnimation{

                running: true

                PropertyAnimation {
                    target: small_gumdrop;
                    property: "y";
                    easing.type: Easing.Linear
                    from: 1000;
                    to: 60;
                    duration: tube_animation.leg1;
                }

                ParallelAnimation{
                    PropertyAnimation {
                        target: small_gumdrop;
                        property: "x";
                        easing.type: Easing.Linear;
                        from: 670;
                        to: -5;
                        duration: tube_animation.leg2;
                    }
                    PropertyAnimation {
                        target: small_gumdrop;
                        property: "y";
                        easing.type: Easing.Linear;
                        to: -27;
                        duration: tube_animation.leg2;
                    }
                }

                ParallelAnimation{
                    PropertyAnimation {
                        target: small_gumdrop;
                        property: "x";
                        easing.type: Easing.Linear;
                        to: 356;
                        duration: tube_animation.leg3;
                    }
                    PropertyAnimation {
                        target: small_gumdrop;
                        property: "y";
                        easing.type: Easing.InBack;
                        to: 84;
                        duration: tube_animation.leg3;
                    }
                }
            }
        }

    ParallelAnimation{
        RotationAnimation {
            target: small_gumdrop
            duration: tube_animation.leg4 -200
            easing.type: Easing.OutQuad
            from: -1080
            to: -15

        }
        PropertyAnimation {
            target: small_gumdrop;
            property: "x";
            easing.type: Easing.Linear;
            to: tube_animation.endOfConverorBeltX;
            duration: tube_animation.leg4;
        }
        PropertyAnimation {
            target: small_gumdrop;
            property: "y";
            easing.type: Easing.Linear;
            easing.amplitude: 0.70
            to: tube_animation.endOfConverorBeltY;
            duration: tube_animation.leg4;
        }

    }

    ParallelAnimation{

        PropertyAnimation {
            target: small_gumdrop;
            property: "x";
            easing.type: Easing.Linear;
            to: tube_animation.endOfConverorBeltX - small_gumdrop.width - 20;
            duration: tube_animation.leg5;
        }
        PropertyAnimation {
            target: small_gumdrop;
            property: "y";
            easing.type: Easing.InExpo;
            to: 900 //TODO: into box
            duration: tube_animation.leg5;
        }
        RotationAnimation{
            target: small_gumdrop
            duration: tube_animation.leg5
            from: -15
            to: -375
        }

    }






    PropertyAnimation{
        target: small_gumdrop;
        property: "x";
        to: 670;
        duration: 0;
    }
}*/

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
        z: 85

        states: [
            State{

                name: "CLEAR"

                PropertyChanges {

                    target: pauseOpacity
                    opacity: 0
                }
            },

            State{

                name: "OPAQUE"

                PropertyChanges {

                    target: pauseOpacity
                    opacity: 0.75
                }
            }

        ]

        transitions: [
            Transition{
                from: "CLEAR"
                to: "OPAQUE"
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
            onClicked: myGameMenu.state = "VISIBLE"
        }
    }
}
