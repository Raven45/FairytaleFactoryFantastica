import QtQuick 2.0
import QtMultimedia 5.0

Item {
    id: hanselClaw

    Connections{
        target: page
        onStartPickUpHansel:{
            takeHanselsHead.start()
        }

        onClawHasHansel:{
            liftHanselTimer.start()
        }

        onHanselIsOverOven:{
            killHanselTimer.start()
        }

        onBackToMainMenu:{
            takeHanselsHead.stop()
            liftHanselTimer.stop()
            killHanselTimer.stop()
            moveHanselToOven.stop()
            burnHanselToDeath.stop()
            hanselClaw.anchors.horizontalCenterOffset = -66;
            hanselClaw.anchors.verticalCenterOffset = -1100;
        }
    }

    SoundEffect {
        id: fireSound
        source: "crackling-fire.wav"
    }



    SequentialAnimation{
        id: takeHanselsHead
        running: false

        ScriptAction {
            script: {
                hanselClawSprite.jumpTo("openEmptyClawSprite")
                pauseOpacity.state = "EXECUTION";
                if(_SOUND_CHECK_FLAG) fireSound.play();
            }
        }

        NumberAnimation{
            target: hanselClaw.anchors
            properties:"verticalCenterOffset"
            to: -136
            duration: 800
            easing.type: Easing.OutSine
        }
        ScriptAction{
            script: {
                hanselClawSprite.jumpTo("closeEmptyClawSprite")
                clawHasHansel();
            }
        }

    }

    Timer{
        id: liftHanselTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:{
            moveHanselToOven.start()
        }
    }

    Timer{
        id: killHanselTimer

        interval: 2000
        running: false
        repeat: false
        onTriggered:{
            burnHanselToDeath.start()
        }
    }

    SequentialAnimation {
        id: moveHanselToOven
        running: false

        NumberAnimation { target: platformHansel; property: "y"; to: platformHansel.y - 100; duration: 400; easing.type: Easing.OutSine }
        NumberAnimation { target: platformHansel; property: "x"; to: gameScreen.width/2 - platformHansel.width/2; duration: 1200; easing.type: Easing.OutSine }
        ScriptAction {
            script: {
                hanselIsOverOven();
            }
        }
    }

    SequentialAnimation {
        id: burnHanselToDeath
        running: false

        ParallelAnimation {
            NumberAnimation { target: platformHansel; property: "y"; duration: 1000; to: y+ 200; easing.type: Easing.InQuad }
            ScriptAction {
                script: {
                    droppedSomethingInOven()
                }
            }
            NumberAnimation {

                target: hanselClaw.anchors
                properties:"verticalCenterOffset"
                to: -1300
                duration: 1000
                easing.type:Easing.Linear
            }
        }
    }

    SpriteSequence{
        id: hanselClawSprite
        width: _CLAW_SPRITE_WIDTH
        height: _CLAW_SPRITE_WIDTH

        property string reverseSource: "teal-claw-reverse-spritesheet.png"
        sprites:[

            Sprite {
                name: "closeEmptyClawSprite"
                source: "teal-claw-spritesheet.png"
                frameCount: 14
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
                source: hanselClawSprite.reverseSource
                frameCount: 14
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
                source: hanselClawSprite.reverseSource
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
        anchors.bottom: hanselClawSprite.top
        anchors.bottomMargin: -41
        anchors.horizontalCenter: hanselClawSprite.horizontalCenter
        anchors.horizontalCenterOffset: -2
        z: 30
    }


}
