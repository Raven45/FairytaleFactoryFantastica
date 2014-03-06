import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import  QtGraphicalEffects 1.0

Item{

    property int myQuadrantToRotate
    property int myRotationDirection
    property bool myMirror: false
    property int myRotation: 0


    Glow {
            id: glowEffect
           anchors.fill: arrow
           radius: 9
           samples: 16
           color: "yellow"
           source: arrow
           visible: false
       }

    Image {
        id: arrow
        fillMode: Image.PreserveAspectFit
        z: 14
        width : 50
        height: width
        source: "arrow.png"
        mirror: parent.myMirror

        Connections{
            target: page
            onReadyForRotation:{
                glowEffect.visible = true;
            }
        }

        Connections{
            target: page
            onRotationClicked:{
                    glowEffect.visible = false;
            }
        }

       function turnOffGlow(){
            glowEffect.color = "black"
       }

        MouseArea{
            id: myMouseArea
            anchors.fill: parent
            onClicked:{
                if(!menuIsShowing){
                    if(guiPlayerCanClickRotation){
                        console.log("clicked to rotate direction " + myRotationDirection );

                        page.gameMessage = "OK";

                        console.log("2. set setGuiTurnRotation ");
                        gameController.setGuiTurnRotation( myQuadrantToRotate , myRotationDirection );
                        page.gameMessage = "rotating quadrant " + myQuadrantToRotate + " to the " + ((myRotationDirection == 0)?"RIGHT":"LEFT");
                        rotationClicked(myQuadrantToRotate, myRotationDirection);
                    }
                }
            }
        }
    }
}
