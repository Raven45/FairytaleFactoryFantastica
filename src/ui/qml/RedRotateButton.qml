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
        z: 14
        rotation: -(parent.rotation)

        Connections{
            target: page
            onReadyForRotation:{
                if(guiPlayerCanClickRotation && !menuIsShowing){
                    red_rotate_glowEffect.visible = true;
                }
            }
        }

        Connections{
            target: page
            onRotationClicked:{
                if (!menuIsShowing){
                    red_rotate_glowEffect.visible = false;
                }
            }
        }

       function turnOffGlow(){
            red_rotate_glowEffect.color = "black"
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
