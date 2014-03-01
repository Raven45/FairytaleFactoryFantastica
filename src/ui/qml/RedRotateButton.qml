import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    property int quadToRo
    property int roDir
    property var direction_string


    Image {
        id: red_rotate_button
        source: "red-rotate-" + direction_string + ".png"
        width: 125; height: 125
        z: 1
        rotation: -(parent.rotation)

        Glow {
           id: red_rotate_glowEffect
           anchors.fill: red_rotate_button
           radius: 14
           samples: 16
           color: "red"
           source: red_rotate_button
           visible: false
           z: 0
        }

        Connections{
            target: page
            onReadyForRotation:{
                red_rotate_glowEffect.visible = true
            }
        }

        Connections{
            target: page
            onRotationClicked:{
                red_rotate_glowEffect.visible = false
            }
        }

       function turnOffGlow(){
            glowEffect.color = "black"
       }

        MouseArea {
            anchors.fill: red_rotate_button

            onClicked:{

                console.log("clicked to rotate direction " + roDir );
                console.log("2. set setGuiTurnRotation ");

                gameController.setGuiTurnRotation( quadToRo , roDir );
                rotationClicked(quadToRo, roDir);
            }


        }
    }
}
