import QtQuick 2.0
Item{

    property int startDelay





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
        width: 100; height: 100; z: 2
        scale: 0.65
        x: parent.width/2 - (small_gumdrop.width/2)
        y: 900 + small_gumdrop.height
        source: "teal-gumdrop-centered.png"
    }


    SequentialAnimation{
        id: tube_animation
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
            to: tube_animation.endOfConverorBeltX - small_gumdrop.width - 40;
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
}
}
