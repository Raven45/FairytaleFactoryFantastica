import QtQuick 2.0
import QtMultimedia 5.0

Item {
    id: witchClaw

    Connections{
        target: page
        onStartPickUpWitch:{
            takeWitchsHead.start()
        }

        onClawHasWitch:{
            liftWitchTimer.start()
        }

        onWitchIsOverOven:{
            killWitchTimer.start()
        }

        onBackToMainMenu:{
            takeWitchsHead.stop()
            liftWitchTimer.stop()
            killWitchTimer.stop()
            moveWitchToOven.stop()
            burnWitchToDeath.stop()
            witchClaw.anchors.horizontalCenterOffset = -64;
            witchClaw.anchors.verticalCenterOffset = -1100;
        }
    }

    SoundEffect {
        id: fireSound
        source: "crackling-fire.wav"
    }

    SequentialAnimation{
        id: takeWitchsHead
        running: false

        ScriptAction {
            script: {
                witchClawSprite.jumpTo("openEmptyClawSprite")
                pauseOpacity.state = "EXECUTION";
                if(_SOUND_CHECK_FLAG) fireSound.play()
            }
        }

        NumberAnimation{
            target: witchClaw.anchors
            properties:"verticalCenterOffset"
            to: -210
            duration: 800
            easing.type: Easing.OutSine
        }
        ScriptAction{
            script: {
                witchClawSprite.jumpTo("closeEmptyClawSprite")
                clawHasWitch();
            }
        }

    }

    Timer{
        id: liftWitchTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:{
            moveWitchToOven.start()
        }
    }

    Timer{
        id: killWitchTimer

        interval: 2000
        running: false
        repeat: false
        onTriggered:{
            burnWitchToDeath.start()
        }
    }

    SequentialAnimation {
        id: moveWitchToOven
        running: false

        NumberAnimation { target: platformWitch; property: "y"; to: platformWitch.y - 125; duration: 400; easing.type: Easing.OutSine }
        NumberAnimation { target: platformWitch; property: "x"; to: gameScreen.width/2 - platformWitch.width/2; duration: 1200; easing.type: Easing.OutSine }
        ScriptAction {
            script: {
                witchIsOverOven();
            }
        }
    }

    SequentialAnimation {
        id: burnWitchToDeath
        running: false

        ParallelAnimation {
            NumberAnimation { target: platformWitch; property: "y"; duration: 1000; to: y+ 200; easing.type: Easing.InQuad }
            ScriptAction {
                script: {
                    droppedSomethingInOven()
                }
            }
            NumberAnimation {

                target: witchClaw.anchors
                properties:"verticalCenterOffset"
                to: -1100
                duration: 1000
                easing.type:Easing.Linear
            }
        }
    }

    SpriteSequence{
        id: witchClawSprite
        width: _CLAW_SPRITE_WIDTH
        height: _CLAW_SPRITE_WIDTH

        property string reverseSource: "teal-claw-reverse-spritesheet.png"
        sprites:[

            Sprite{
                name: "closeEmptyClawSprite"
                source: "teal-claw-spritesheet.png"
                frameCount: 8
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
                source: "teal-claw-spritesheet.png"
                frameCount: 1
                frameX: 600
                frameY: 1200
                frameDuration: 0
                frameWidth: 200
                frameHeight: 200
            },

            Sprite{
                name: "openEmptyClawSprite"
                source: witchClawSprite.reverseSource
                frameCount: 8
                frameX: 0
                frameY: 1400
                frameDuration: 1000/24
                frameWidth: 200
                frameHeight: 200

                to: {
                    "stillEmptyOpenClawSprite":1
                }
            },

            Sprite{
                name: "stillEmptyOpenClawSprite"
                source: witchClawSprite.reverseSource
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
        anchors.bottom: witchClawSprite.top
        anchors.bottomMargin: -41
        anchors.horizontalCenter: witchClawSprite.horizontalCenter
        anchors.horizontalCenterOffset: -2
        z: 30
    }


}


