import QtQuick 2.0

Item {

    property string source
    property string reverseSource
    property string type

    function reset(){
        if( type == "TEAL" ){
            visible = true;
        }else{
            visible = false;
        }

        clawSprite.jumpTo("stillEmptyClosedClawSprite");
        x = _CLAW_X_HOME;
        y = _CLAW_Y_HOME;

    }

    id: root

    Connections{
        target:page
        onReadyToOpenClaw:{
            if( type == whichClaw ){
                clawSprite.jumpTo("dropPieceSprite");
                clawEndSpriteTimer.startTimer()
                showPiece( qIndex, pIndex );
            }
        }

        onGetFromCan:{
            if( type == whichClaw ){
                visible = true;
                console.log( " showing " + type + " claw and hiding other, moving across top of screen.")
                moveToCan.start();
            }
            else{
                visible = false;
            }
        }
    }

    NumberAnimation on x{
        id: moveToCan
        to: type == "PURPLE"? _RIGHT_CAN_X : _LEFT_CAN_X
        duration: _CLAW_X_TO_CAN_DURATION
        running: false
        onStopped: {
            x = to;

            console.log( "starting to open claw and move down to can")
            moveYToCan.start();
        }
    }

    NumberAnimation on y{
        id: moveYToCan
        to: ( type == "PURPLE"? _RIGHT_CAN_Y : _LEFT_CAN_Y ) - _CAN_HEIGHT
        duration: _CLAW_Y_TO_CAN_DURATION
        running: false
        onStopped: {
            y = to;
            console.log( "opening and scaling back " + type + " claw");
            scaleOutAnimation.start()
            clawSprite.jumpTo("openEmptyClawSprite");
            //waitInCan.startTimer();
        }
    }

    NumberAnimation on scale{
        id: scaleOutAnimation
        to: 0.65
        duration: _CLAW_PAUSE_OVER_CAN_BEFORE_DURATION
        running: false
        onStopped:{
            console.log( "moving into can")
            moveYIntoCan.start();
        }
    }

    NumberAnimation on y{
        id: moveYIntoCan
        to: type == "PURPLE"? _RIGHT_CAN_Y : _LEFT_CAN_Y
        duration: _CLAW_MOVE_INTO_CAN_DURATION
        running: false
        onStopped: {
            y = to;
            console.log( "waiting in can")
            waitInCan.startTimer();
            clawSprite.jumpTo("pickUpPieceSprite");
            //waitInCan.startTimer();
        }
    }

    QmlTimer{
        id: waitInCan
        duration: _CLAW_TIME_IN_CAN_DURATION
        onTriggered:{
            console.log( "moving out of can")
            moveOutOfCan.start()
        }
    }

    NumberAnimation on y{
        id: moveOutOfCan
        to: (type == "PURPLE"? _RIGHT_CAN_Y : _LEFT_CAN_Y) - _CAN_HEIGHT
        duration: _CLAW_MOVE_OUT_OF_CAN_DURATION
        onStopped: {
            console.log( "done moving out of can (boardHoleButton's timer is about to trigger)")
            y = to;
            scaleInAnimation.start()
        }
    }

    NumberAnimation on scale{
        id: scaleInAnimation
        to: 1
        duration: _CLAW_PAUSE_OVER_CAN_AFTER_DURATION
    }


    QmlTimer{
        id: clawEndSpriteTimer
        duration: _CLAW_OPEN_DURATION + 20
        onTriggered:{
            makeRightCanGoBack();
            moveToHome.start()

            if( (guiPlayerIsWhite && type == "TEAL" ) || (!guiPlayerIsWhite && type == "PURPLE") ){
                readyForRotation();
            }
        }

    }

    NumberAnimation on x{
        id: moveToHome
        to: _CLAW_X_HOME
        duration: _CLAW_MOVE_DURATION * 3 / 4

        onStopped: {
            x = to;
            resetRightCan();
            moveYToHome.start();
        }
    }

    NumberAnimation on y{
        id: moveYToHome
        to: _CLAW_Y_HOME
        duration: _CLAW_MOVE_DURATION / 4

        onStopped: {
            y = to;
        }
    }








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
                    "stillEmptyClosedClawSprite":1
                }
            },
            Sprite{
                name: "stillEmptyClosedClawSprite"
                source: root.source
                frameCount: 1
                frameX: 1200
                frameY: 1600
                frameDuration: _CLAW_MOVE_DURATION
                frameWidth: 200
                frameHeight: 200
            },
            Sprite{
                name: "stillFullClawSprite"
                source: root.source
                frameCount: 1
                frameX: 0
                frameY: 0
                frameWidth: 200
                frameHeight: 200
            },

            Sprite{
                name: "openEmptyClawSprite"
                source: root.reverseSource
                frameCount: 72 - 36
                frameX: 800
                frameY: 800
                frameDuration: _CLAW_Y_TO_CAN_DURATION / frameCount
                frameWidth: 200
                frameHeight: 200

                to: {
                    "stillEmptyOpenClawSprite":1
                }
            },

            Sprite{
                name: "pickUpPieceSprite"

                source: root.reverseSource
                frameCount: 36
                frameX: 0
                frameY: 0
                frameDuration: (_CLAW_TIME_IN_CAN_DURATION + _CLAW_MOVE_OUT_OF_CAN_DURATION ) / 36
                frameWidth: 200
                frameHeight: 200

                to:{
                    "stillFullClawSprite":1
                }
            },



            Sprite{
                name: "stillEmptyOpenClawSprite"
                source: root.reverseSource
                frameCount: 1
                frameX: 1200
                frameY: 1600
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


    Image {
        id: clawPipe
        source: "bar.png"
        width: 40
        height: 700
        anchors.bottom: clawSprite.top
        anchors.bottomMargin: -41
        anchors.horizontalCenter: clawSprite.horizontalCenter
        anchors.horizontalCenterOffset: -2
        z: 400
    }

}
