import QtQuick 2.0
Item{

    property int startDelay
    property bool isStrayPiece:false




    QmlTimer{
        id:root
        Connections{
            target: page
            onStartPieceAnimations:{
                root.startTimer();
            }
        }
        duration: startDelay
        onTriggered:{
            tube_animation.start();
        }
    }

    Image {
        id: small_gumdrop
        width: 100;
        height: 100;
        z: 2 + (startDelay % 2)
        scale: 0.65
        x: 658 + (startDelay % 4) * 7;
        y: 900 + small_gumdrop.height
        source: isStrayPiece? "teal-gumdrop-centered.png" : "purp-gumdrop-centered.png" ;
    }


    SequentialAnimation{
        id: tube_animation
        loops: Animation.Infinite

        property int leg1: 1200 + (startDelay % 1001)
        property int leg2: 500 + (startDelay % 101)
        property int leg3: 650 + (startDelay % 101)
        property int leg4: 3000
        property int leg5: 1200
        property int _THROW_DURATION: leg1 + leg2 + leg3

        property int endOfConverorBeltX: gameScreen.width - 265     //Left: 165
        property int endOfConverorBeltY: 134
        property int startOfConverorBeltX: gameScreen.width - 456   //Left: 356
        property int startOfConverorBeltY: 84

        ParallelAnimation{

            RotationAnimation {
                target: small_gumdrop
                duration: tube_animation._THROW_DURATION / ((startDelay % 3) + 2)
                to: -385
                loops: tube_animation._THROW_DURATION /duration

            }

            SequentialAnimation{

                PropertyAnimation {
                    target: small_gumdrop;
                    property: "y";
                    easing.type: Easing.Linear
                    from: 900 + small_gumdrop.height;
                    to: 58;
                    duration: tube_animation.leg1;
                }

                ParallelAnimation{
                    PropertyAnimation {
                        target: small_gumdrop;
                        property: "x";
                        easing.type: Easing.Linear;
                        to: gameScreen.width - 5; //Left: -5
                        duration: tube_animation.leg2;
                    }
                    PropertyAnimation {
                        target: small_gumdrop;
                        property: "y";
                        easing.type: Easing.Linear;
                        to: -34 + (startDelay % 8)*10;
                        duration: tube_animation.leg2;
                    }
                }

                ParallelAnimation{
                    PropertyAnimation {
                        target: small_gumdrop;
                        property: "x";
                        easing.type: Easing.Linear;
                        to: tube_animation.startOfConverorBeltX;
                        duration: tube_animation.leg3;
                    }
                    PropertyAnimation {
                        target: small_gumdrop;
                        property: "y";
                        easing.type: Easing.InBack;
                        to: tube_animation.startOfConverorBeltY;
                        duration: tube_animation.leg3;
                    }
                }
            }
        }

    ParallelAnimation{
        RotationAnimation {
            target: small_gumdrop
            duration: 1000
            easing.type: Easing.OutQuad
            from: -385   //Left: 385
            to: -705     //Left: 705

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
            //easing.amplitude: 0.70
            to: tube_animation.endOfConverorBeltY;
            duration: tube_animation.leg4;
        }

    }

    ParallelAnimation{

        PropertyAnimation {
            target: small_gumdrop;
            property: "x";
            easing.type: Easing.Linear;
            to: tube_animation.endOfConverorBeltX + 65; //Left: - 65
            duration: tube_animation.leg5;
        }
        PropertyAnimation {
            target: small_gumdrop;
            property: "y";
            easing.type: Easing.InExpo;
            to: 900 + small_gumdrop.height //TODO: into box
            duration: tube_animation.leg5;
        }
        RotationAnimation{
            target: small_gumdrop
            duration: tube_animation.leg5
            from: 15    //Left: -15
            to: 200     //Left: -200
        }

    }


    PropertyAnimation {
        //Resets to middle of the screen with slight randomness
        target: small_gumdrop;
        property: "x";
        to: 658 + (startDelay % 4) * 7;
        duration: startDelay % 700;
    }

}
}
