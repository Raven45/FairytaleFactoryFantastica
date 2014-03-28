import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Particles 2.0

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

        onReadyToStartOnePersonPlay:{
            state = "UNLOCKED"
        }

        onPlayRotateAnimationOnQuadrant:{

            switch( parseInt( quadrantToRotate ) ){
                case 0: quadrant0.rotate(rotationDirection);break;
                case 1: quadrant1.rotate(rotationDirection);break;
                case 2: quadrant2.rotate(rotationDirection);break;
                case 3: quadrant3.rotate(rotationDirection);break;
                default: console.log( "ERROR! bad quadrantIndex of " + quadrantToRotate + " received.\n" );
            }
            boardShake.start();
        }
    }

   ParticleSystem{

    anchors.fill: parent
    z: 50
    ImageParticle {
        groups: ["spell"]
        source: "qrc:///particleresources/glowdot.png"
        color: "#11111111"
        colorVariation: 1
    }



    Emitter {
        id: spellCaster
        group: "spell"
        emitRate: 400
        lifeSpan: 2700
        lifeSpanVariation:100
        size: 30
        endSize: 300
        sizeVariation: 10
        enabled: false
        acceleration: PointDirection {y: 0; yVariation: 150; x: 0; xVariation: 150;}
        velocity:
            AngleDirection { id: spellAngle; angle: 0; magnitude: 250; angleVariation:30; magnitudeVariation: 100}
        NumberAnimation { id: angleAnimation; target: spellAngle ; loops: 1; running: false; property: "angle"; duration: _SPREAD_DURATION; from: 360; to: 0;

            onStopped: {
                spellCaster.enabled = false;
            }
        }

        Connections{
            target: page;
            onSpreadIcing:{
                    var goTo = getXYOffset(qIndex,pIndex);
                    spellCaster.x = goTo.x + _SPELL_X_OFFSET;
                    spellCaster.y = goTo.y + _SPELL_Y_OFFSET;
                    angleAnimation.start();
                    spellCaster.enabled = true;
                }
            }
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







    Image{
        id: steel_platform
        fillMode: Image.PreserveAspectFit
        width : 420
        height: width
        anchors.centerIn: parent
        source: "steel-platform.png"
        z: 20
    }




    SequentialAnimation {
        id: boardShake
        loops: 7
        PropertyAnimation { easing.type: Easing.InQuad; duration:_ROTATION_ANIMATION_DURATION/28; targets: steel_platform; properties: "rotation"; to: .5 }
        PropertyAnimation { easing.type: Easing.InQuad; duration:_ROTATION_ANIMATION_DURATION/28; target: steel_platform; properties: "rotation"; to: 0 }
        PropertyAnimation { easing.type: Easing.InQuad; duration: _ROTATION_ANIMATION_DURATION/28; target: steel_platform; properties: "rotation"; to: -.5 }
        PropertyAnimation { easing.type: Easing.InQuad; duration:_ROTATION_ANIMATION_DURATION/28; target: steel_platform; properties: "rotation"; to: 0 }

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


    ClawHouse {
        id: clawHouse
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
