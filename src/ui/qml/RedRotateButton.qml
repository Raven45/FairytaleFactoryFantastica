import QtQuick 2.0
import QtGraphicalEffects 1.0
Item {

    property int quadToRo
    property int roDir
    property var direction_string
    Glow {
       id: red_rotate_glowEffect
       anchors.fill: red_rotate_button
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
        source: "red-rotate-" + direction_string + ".png"
        width: 125; height: 125
        z: 19
        rotation: -(parent.rotation)

        Connections{
            target: page
            onTurnRotationGlowOn:{
                red_rotate_glowEffect.visible = true;
            }
        }

       function turnOffGlow(){
            red_rotate_glowEffect.color = "black"
       }

        MouseArea {
            anchors.fill: red_rotate_button
            onClicked:{



                if( guiPlayerCanClickRotation && !allGameScreenButtonsAreLocked ){
                    console.log("clicked to rotate direction " + roDir );
                    lockQuadrantRotation();
                    animateTbarsIn.start();
                    //red_rotate_glowEffect.visible = false;
                    gameController.setGuiTurnRotation( quadToRo , roDir );
                    rotationLegallyClicked(quadToRo, roDir);
                }

            }


        }
    }
}
