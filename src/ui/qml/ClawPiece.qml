import QtQuick 2.0

Item {

    property string source

    id: root

    Connections{
        target:page
        onReadyToOpenClaw:{
            if( type == whichClaw ){
                console.log("starting spriteTimer")
                //spriteTimer.startTimer()

                clawSprite.jumpTo("dropPieceSprite");
                clawSpriteTimer.startTimer()
                showPiece( qIndex, pIndex );
            }
        }
    }

    QmlTimer{
        id: clawSpriteTimer
        duration: _CLAW_OPEN_DURATION + 20
        onTriggered:{
            console.log("moving to home")
            moveToHome.start()

            if( (guiPlayerIsWhite && type == "TEAL" ) || (!guiPlayerIsWhite && type == "PURPLE") ){
                readyForRotation();
            }
        }

    }

    NumberAnimation on x{
        id: moveToHome
        to: _CLAW_X_HOME
        duration: _CLAW_MOVE_DURATION / 2

        onStopped: {
            x = _CLAW_X_HOME;
            moveYToHome.start();
        }
    }

    NumberAnimation on y{
        id: moveYToHome
        to: _CLAW_Y_HOME
        duration: _CLAW_MOVE_DURATION / 2

        onStopped: {
            y = _CLAW_Y_HOME;
        }
    }





    property string type


    SpriteSequence{
        id: clawSprite
        width: 131
        height: 131
        sprites:[

            Sprite{
                name: "dropPieceSprite"

                source: root.source
                frameCount: 36
                frameX: 0
                frameY: 0
                frameDuration: 10
                frameWidth: 200
                frameHeight: 200
                to:{
                    "closeEmptyClawSprite":1
                }
            },
            Sprite{
                name: "closeEmptyClawSprite"
                source: root.source
                frameCount: 72 - 36
                frameX: 800
                frameY: 800
                frameDuration: 10
                frameWidth: 200
                frameHeight: 200
                to: {
                    "stillEmptyClawSprite":1
                }
            },
            Sprite{
                name: "stillEmptyClawSprite"
                source: root.source
                frameCount: 1
                frameX: 1200
                frameY: 1600
                frameDuration: _CLAW_MOVE_DURATION
                frameWidth: 200
                frameHeight: 200
                to:{
                    "stillFullClawSprite":1
                }
            },
            Sprite{
                name: "stillFullClawSprite"
                source: root.source
                frameCount: 1
                frameX: 0
                frameY: 0
                frameWidth: 200
                frameHeight: 200
            }
        ]




    }

    /*AnimatedSprite {
        id: clawSprite
        width: 131
        height: 131
        source: parent.source
        frameCount: 72
        //frameDuration: _CLAW_OPEN_DURATION
        frameWidth: 200
        frameHeight: 200
        currentFrame: 1
        //loops: 1
        running: false
        z: 410
    }*/


    Rectangle {
        id: clawPipe
        width: 22
        height:  1000
        anchors.bottom: clawSprite.top
        anchors.bottomMargin: -13
        anchors.horizontalCenter: clawSprite.horizontalCenter
        anchors.horizontalCenterOffset: -3
        color: "#000000"
        z: 400
    }

}
