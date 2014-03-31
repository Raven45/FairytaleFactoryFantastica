import QtQuick 2.0

Item {
    id: gretelClaw

    Connections{
        target: page
        onStartPickUpGretel:{
            takeGretelsHead.start()
        }

        onClawHasGretel:{
            liftGretelTimer.start()
        }

        onGretelIsOverOven:{
            killGretelTimer.start()
        }
    }



    SequentialAnimation{
        id: takeGretelsHead
        running: false

        NumberAnimation{
            target: gretelClaw.anchors
            properties:"horizontalCenterOffset"
            to: -64
            duration: 800
            easing.type: Easing.OutSine
        }

        ScriptAction {
            script: {
                gretelClawSprite.jumpTo("openEmptyClawSprite")
                pauseOpacity.state = "EXECUTION";
            }
        }

        NumberAnimation{
            target: gretelClaw.anchors
            properties:"verticalCenterOffset"
            to: -136
            duration: 800
            easing.type: Easing.OutSine
        }
        ScriptAction{
            script: {
                gretelClawSprite.jumpTo("closeEmptyClawSprite")
                clawHasGretel();
            }
        }

    }

    Timer{
        id: liftGretelTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:{
            moveGretelToOven.start()
        }
    }

    Timer{
        id: killGretelTimer

        interval: 2000
        running: false
        repeat: false
        onTriggered:{
            burnGretelToDeath.start()
        }
    }

    SequentialAnimation {
        id: moveGretelToOven
        running: false

        NumberAnimation { target: platformGretel; property: "y"; to: platformGretel.y - 125; duration: 400; easing.type: Easing.OutSine }
        NumberAnimation { target: platformGretel; property: "x"; to: gameScreen.width/2 - platformGretel.width/2; duration: 1200; easing.type: Easing.OutSine }
        ScriptAction {
            script: {
                gretelIsOverOven();
            }
        }
    }

    SequentialAnimation {
        id: burnGretelToDeath
        running: false

        ParallelAnimation {
            NumberAnimation { target: platformGretel; property: "y"; duration: 1000; to: y+ 200; easing.type: Easing.InQuad }
            ScriptAction {
                script: {
                    droppedSomethingInOven()
                }
            }
            NumberAnimation {

                target: gretelClaw.anchors
                properties:"verticalCenterOffset"
                to: -1100
                duration: 1000
                easing.type:Easing.Linear
            }
        }
        NumberAnimation { target: gretelClaw.anchors; property: "horizontalCenterOffset"; to: 1200; duration: 1800; easing.type: Easing.OutSine }

    }

    SpriteSequence{
        id: gretelClawSprite
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
                source: gretelClawSprite.reverseSource
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
                source: gretelClawSprite.reverseSource
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
        anchors.bottom: gretelClawSprite.top
        anchors.bottomMargin: -41
        anchors.horizontalCenter: gretelClawSprite.horizontalCenter
        anchors.horizontalCenterOffset: -2
        z: 30
    }


}

