import QtQuick 2.0
import QtMultimedia 5.0

Item {

    id: root

    property string source
    property string reverseSource
    property string type

    property int yDirection: 0

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


    /*SoundEffect {
        id: clawSound
        source: "small-servo.wav"
    }*/


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


    NumberAnimation {
        targets: [root, clawHouse]
        properties: "x"
        id: moveToCan
        to: type == "PURPLE"? _RIGHT_CAN_X : _LEFT_CAN_X
        duration: _CLAW_X_TO_CAN_DURATION
        running: false
        //onStarted: if(_SOUND_CHECK_FLAG) clawSound.play()
        onStopped: {
            x = to;

            console.log( "starting to open claw and move down to can")
            clawMovingDown();
            moveYToCan.start();
        }
    }

    NumberAnimation on y{
        id: moveYToCan
        to: ( type == "PURPLE"? _RIGHT_CAN_Y : _LEFT_CAN_Y ) - _CAN_HEIGHT
        duration: _CLAW_Y_TO_CAN_DURATION
        running: false
        //onStarted: if(_SOUND_CHECK_FLAG) clawSound.play()
        onStopped: {
            y = to;
            finishedClawMovingY();

            console.log( "opening and scaling back " + type + " claw");
            scaleOutAnimation.start()
            clawSprite.jumpTo("openEmptyClawSprite");
            //waitInCan.startTimer();
        }
    }

    ParallelAnimation{
        id: scaleOutAnimation

        NumberAnimation {
            targets: [root, clawHouse]
            properties: "scale"
            easing.type: Easing.OutSine
            to: 0.65
            duration: _CLAW_PAUSE_OVER_CAN_BEFORE_DURATION
            running: false

        }

        NumberAnimation{
            target: clawHouse
            properties: "x"
            easing.type: Easing.OutSine
            to: clawHouse.x - _CLAW_HOUSE_X_MOVE_WHEN_SHRINKING
            duration: _CLAW_PAUSE_OVER_CAN_BEFORE_DURATION

        }
        //onStarted: if(_SOUND_CHECK_FLAG) clawSound.play()
        onStopped:{
            console.log( "moving into can")
            clawMovingDown();
            moveYIntoCan.start();
        }

    }



    NumberAnimation on y{
        id: moveYIntoCan
        to: type == "PURPLE"? _RIGHT_CAN_Y : _LEFT_CAN_Y
        duration: _CLAW_MOVE_INTO_CAN_DURATION
        running: false
        easing.type: Easing.OutSine
        //onStarted: if(_SOUND_CHECK_FLAG) clawSound.play()
        onStopped: {
            y = to;
            console.log( "waiting in can")
            finishedClawMovingY();
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
            clawMovingUp();
            moveOutOfCan.start()
        }
    }

    NumberAnimation on y{
        id: moveOutOfCan
        running: false
        easing.type: Easing.OutSine
        to: (type == "PURPLE"? _RIGHT_CAN_Y : _LEFT_CAN_Y) - _CAN_HEIGHT
        duration: _CLAW_MOVE_OUT_OF_CAN_DURATION
        //onStarted: if(_SOUND_CHECK_FLAG) clawSound.play()
        onStopped: {
            console.log( "done moving out of can (boardHoleButton's timer is about to trigger)")
            y = to;
            finishedClawMovingY()
            scaleInAnimation.start()
        }
    }

     ParallelAnimation{

         id: scaleInAnimation
         running: false
        NumberAnimation {
            targets: [root, clawHouse]
            properties: "scale"
            easing.type: Easing.OutSine
            to: 1
            duration: _CLAW_PAUSE_OVER_CAN_AFTER_DURATION
            running: false
        }

        NumberAnimation{
            target: clawHouse
            easing.type: Easing.OutSine
            properties: "x"
            to: clawHouse.x + _CLAW_HOUSE_X_MOVE_WHEN_SHRINKING
            duration: _CLAW_PAUSE_OVER_CAN_AFTER_DURATION

        }


    }


    QmlTimer{
        id: clawEndSpriteTimer
        duration: _CLAW_OPEN_DURATION + 20
        onTriggered:{

            //need to make the can-front image on the right side go back Z-wise so that we don't send the claw "through" it
            makeRightCanGoBack();

            moveClawToHome.start();

            var thisClawIsNetworkOrAI = (networkOrAIIsTeal && type == "TEAL") || (!networkOrAIIsTeal && type != "TEAL");

            if( isVersusGame || !thisClawIsNetworkOrAI ){
                readyForUserToClickRotation();
            }
        }

    }

    Connections{
        target: page
        onClearBoard:{
            root.x = _CLAW_X_HOME;
            root.y = _CLAW_Y_HOME;
            clawHouse.x = _CLAW_X_HOME;
            clawHouse.y = _CLAW_Y_HOME;
            clawHouse.scale = 1;
            root.scale = 1;
        }
    }



    NumberAnimation {
        targets: [ root, clawHouse ]
        properties: "x"
        running: false
        id: moveClawToHome
        to: _CLAW_X_HOME
        duration: _CLAW_MOVE_DURATION * 3 / 4
        easing.type: Easing.OutSine
        onStopped: {
            root.x = to;
            clawHouse.x = to;
            resetRightCan();
            clawMovingUp();
            moveYToHome.start();
        }
    }

    NumberAnimation on y{
        id: moveYToHome
        running: false
        to: _CLAW_Y_HOME
        duration: _CLAW_MOVE_DURATION / 4
        easing.type: Easing.OutSine
        //onStarted: if(_SOUND_CHECK_FLAG) clawSound.play()
        onStopped: {
            waitingForAnimationsToFinish = false;
            y = to;
            finishedClawMovingY();

        }
    }








    SpriteSequence{
        id: clawSprite
        width: _CLAW_SPRITE_WIDTH
        height: _CLAW_SPRITE_WIDTH


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

    Image {
        id: clawPipe
        source: "bar.png"

        width: 40
        height: 700
        anchors.bottom: clawSprite.top
        anchors.bottomMargin: -41
        anchors.horizontalCenter: clawSprite.horizontalCenter
        anchors.horizontalCenterOffset: -2
        z: 30
    }

}
