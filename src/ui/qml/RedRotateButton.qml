import QtQuick 2.0
import QtGraphicalEffects 1.0
Rectangle {
    color:"transparent"
    property bool isClockwise
    property int quadToRo
    property int roDir

    NumberAnimation{
        id: slowButtonRotationAnimation
        target: red_rotate_button
        properties: "rotation"

        duration: 5000
        from:red_rotate_button.rotation
        to: (isClockwise? red_rotate_button.rotation + 360 : red_rotate_button.rotation - 360 )
        running: false
        loops: Animation.Infinite
    }

    Connections{
        target: page
        onStartRotationOnRedRotationButtons:{
            slowButtonRotationAnimation.start();
        }
    }


    Glow {
       id: red_rotate_glowEffect
       anchors.fill: red_rotate_button
       anchors.centerIn: red_rotate_button
       radius: 16
       samples: 24
       spread: 0.5
       color: "red"
       source: red_rotate_button
       visible: false
       fast: true
       cached: true
    }


    Image {
        id: red_rotate_button
        source: "red-rotate-button.png"
        width: 125; height: 125
        mirror: !isClockwise
        z: 19
        rotation: -(parent.rotation)



        MouseArea {
            anchors.fill: red_rotate_button

            hoverEnabled: true

            onEntered:{
                if( guiPlayerCanClickRotation && !allGameScreenButtonsAreLocked ){
                    red_rotate_glowEffect.visible = true;
                }
            }
            onExited:{
                red_rotate_glowEffect.visible = false;
            }

            onClicked:{



                if( guiPlayerCanClickRotation && !allGameScreenButtonsAreLocked ){
                    console.log("clicked to rotate direction " + roDir );
                    lockQuadrantRotation();
                    slowButtonRotationAnimation.stop();
                    animateTbarsIn.start();
                    gameController.setGuiTurnRotation( quadToRo , roDir );
                    rotationLegallyClicked(quadToRo, roDir);
                }

            }


        }
    }

}
