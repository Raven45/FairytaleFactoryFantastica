import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: pentagoBoard
    width: 575
    height: width
    anchors.centerIn: parent
    color: "transparent"



    state: "LOCKED"

    Connections{
        target: page
        onReadyForRotation:{

  //          lockBoardPieces();
    //        unlockQuadrantRotation();
        }

        onClearBoard:{
            tealClawPiece.reset();
            purpleClawPiece.reset();
            quadrant0.resetRotations();
            quadrant1.resetRotations();
            quadrant2.resetRotations();
            quadrant3.resetRotations();
        }
    }


    states: [
        State{
            name: "LOCKED"
            PropertyChanges {
                target: pentagoBoard
                opacity: 1
            }

            StateChangeScript {
                name: "lockGameBoard"
                script: {
                    page.menuIsShowing = true;
                }
            }

        },
        State{
            name: "UNLOCKED"
            PropertyChanges {
                target: pentagoBoard
                opacity: 1
            }

            StateChangeScript {
                name: "unlockGameBoard"
                script: {
                    page.menuIsShowing = false;
                }
            }
        }

    ]

    transitions: [
        Transition {
            from: "UNLOCKED"
            to: "LOCKED"
            ScriptAction{
                scriptName: "lockGameBoard"
            }
        },
        Transition {
            from: "LOCKED"
            to: "UNLOCKED"
            ScriptAction{
                scriptName: "unlockGameBoard"
            }
        }
]

    Cogs {
         id: leftHighCog
         quadrantToOperateOn: 0
         anchors.top: parent.top
         anchors.topMargin: 190 - _QUADRANT_WIDTH/2 + 20

         anchors.left: parent.left
         anchors.leftMargin: 20
     }

    Cogs {
         id: leftLowCog
         quadrantToOperateOn: 2
         anchors.top: parent.top
         anchors.topMargin: 190 + _QUADRANT_WIDTH/2 + 30

         anchors.left: parent.left
        anchors.leftMargin: 20
     }

     Cogs {
         id: topLeftCog
         quadrantToOperateOn: 0
         rotation: 90
         anchors.top: parent.top
         anchors.topMargin: 20

         anchors.left: parent.left
         anchors.leftMargin: 385  - _QUADRANT_WIDTH/2 - 30
     }
     Cogs {
         id:topRightCog
         quadrantToOperateOn: 1
         rotation: 90
         anchors.top: parent.top
         anchors.topMargin: 20

         anchors.left: parent.left
         anchors.leftMargin: 385 + _QUADRANT_WIDTH/2 - 20
     }


     Cogs {
         id: rightHighCog
         quadrantToOperateOn: 1
         rotation: 180
         anchors.top: parent.top
         anchors.topMargin: 385 - _QUADRANT_WIDTH/2 - 30

         anchors.right: parent.right
         anchors.rightMargin: 20
     }

     Cogs {
         id: rightLowCog
         quadrantToOperateOn: 3
         rotation: 180
         anchors.top: parent.top
         anchors.topMargin: 385 + _QUADRANT_WIDTH/2 - 20

         anchors.right: parent.right
         anchors.rightMargin: 20
     }

     Cogs {
         id:bottomLeftCog
         quadrantToOperateOn: 2
         rotation: -90
         anchors.bottom: parent.bottom
         anchors.bottomMargin: 20

         anchors.left: parent.left
         anchors.leftMargin: 190 - _QUADRANT_WIDTH/2 + 20
     }

     Cogs {
         id: bottomRightCog
         quadrantToOperateOn: 3
         rotation: -90
         anchors.bottom: parent.bottom
         anchors.bottomMargin:20

         anchors.left: parent.left
         anchors.leftMargin: 190 + _QUADRANT_WIDTH/2 + 30
     }





    Tbar {
        anchors.top: parent.top
        anchors.left: parent.left

        pentago_quad: 0
        tbar_rotate_angle: -45
    }

    Tbar {
        anchors.top: parent.top
        anchors.right: parent.right

        pentago_quad: 1
        tbar_rotate_angle: 45
    }

    Tbar {
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        pentago_quad: 2
        tbar_rotate_angle: -135
    }

    Tbar {
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        pentago_quad: 3
        tbar_rotate_angle: 135
    }

    function playRotateAnimationOnQuadrant( quadrantIndex, direction ){

        switch( parseInt( quadrantIndex ) ){
            case 0: quadrant0.rotate(direction);break;
            case 1: quadrant1.rotate(direction);break;
            case 2: quadrant2.rotate(direction);break;
            case 3: quadrant3.rotate(direction);break;
            default: console.log( "ERROR! bad quadrantIndex of " + quadrantIndex + " received.\n" );
        }
    }





    Image{
        id: steel_platform
        fillMode: Image.PreserveAspectFit
        width : 420
        height: width
        anchors.centerIn: parent
        source: "steel-platform.png"
        z: 20
    }

    Rectangle {
        id: quads_rec
        width: 410
        height: width
        color: "transparent"
        anchors.centerIn: pentagoBoard
        border.color: "#363666"
        z: 21
        Quadrant{
            id: quadrant0
            anchors.left: parent.left
            anchors.top: parent.top
            myIndex: 0

        }

        Quadrant{
            id: quadrant1
            anchors.right: parent.right
            anchors.top: parent.top
            myIndex: 1
        }
        Quadrant{
            id: quadrant2
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            myIndex: 2
        }
        Quadrant{
            id: quadrant3
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            myIndex: 3
        }
    }



    Rectangle{
        id: clawHouse
        width: 171
        height: 98
        color: "transparent"

        z:35
        x: _CLAW_X_HOME
        y: _CLAW_Y_HOME + _CLAW_HOUSE_Y_OFFSET

        Image{
            id: clawHouseImg
            width: 171
            height: 98

            z:35
            anchors.left: parent.left
            anchors.leftMargin: _CLAW_HOUSE_X_OFFSET
            source: "clawHouse.png"


        }

        Image{
            id: leftMessyGear
            z:36
            source: "messyGear.png"
            anchors.horizontalCenter: clawHouseImg.horizontalCenter
            anchors.horizontalCenterOffset: -60 * scale
            anchors.verticalCenter: clawHouseImg.verticalCenter

        }

        Image{
            id: rightMessyGear
            z:36
            source: "messyGear.png"
            anchors.horizontalCenter: clawHouseImg.horizontalCenter
            anchors.horizontalCenterOffset:( 60) * scale
            anchors.verticalCenter: clawHouseImg.verticalCenter
        }

        Connections{
            target: page
            onClawMovingUp:{
                gearsPullingClawUp.start()
            }

            onClawMovingDown:{
                gearsPullingClawDown.start()
            }

            onFinishedClawMovingY:{
                gearsPullingClawDown.stop()
                gearsPullingClawUp.stop()
            }
        }

        ParallelAnimation {
            id: gearsPullingClawUp
            loops: Animation.Infinite
            alwaysRunToEnd: false
            running: false

            NumberAnimation{
                target: rightMessyGear;
                properties: "rotation";
                from: rotation
                to: rotation + 360
                duration: 500
            }

            NumberAnimation{
                target: leftMessyGear;
                properties: "rotation";
                from: rotation
                to: rotation - 360
                duration: 500
            }
        }

        ParallelAnimation {
            id: gearsPullingClawDown
            loops: Animation.Infinite
            alwaysRunToEnd: false
            running: false

            NumberAnimation{
                target: rightMessyGear;
                properties: "rotation";
                from: rotation
                to: rotation - 360
                duration: 500
            }

            NumberAnimation{
                target: leftMessyGear;
                properties: "rotation";
                from: rotation
                to: rotation + 360
                duration: 500
            }
        }
    }





    ClawPiece {
        type: "PURPLE"
        id: purpleClawPiece
        z: 30
        source: "purp-claw-spritesheet.png"
        reverseSource: "purp-claw-reverse-spritesheet.png"
        x: _CLAW_X_HOME
        y: _CLAW_Y_HOME


    }

    ClawPiece {
        type: "TEAL"
        id: tealClawPiece
        z: 30
        source: "teal-claw-spritesheet.png"
        reverseSource: "teal-claw-reverse-spritesheet.png"
        x: _CLAW_X_HOME
        y: _CLAW_Y_HOME
    }


}
