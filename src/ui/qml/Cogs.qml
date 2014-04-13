import QtQuick 2.0
import QtQuick.Particles 2.0

Item {

    property int quadrantToOperateOn

    Connections{
        target: page
        onTurnCogs:{
            if( quadrantIndex == quadrantToOperateOn){

                if( direction == "LEFT" ){
                    cogsSprite.jumpTo("leftCogsSprite")

                }
                else if( direction == "RIGHT" ){
                    cogsSprite.jumpTo( "rightCogsSprite")
                }
            }
        }
    }

    ParticleSystem {
        width: 1; height: 1
        anchors.centerIn:  cogsSprite

        ImageParticle {
            groups: ["boardSmoke"]
            source: "qrc:///particleresources/glowdot.png"
            color: "#8F333333"
            blueVariation: 0.05
            //colorVariation: 0.5
        }

        Emitter {
            anchors.fill: parent
            group: "boardSmoke"
            emitRate: 120
            lifeSpan: 3000
            lifeSpanVariation:1000
            size: 20
            endSize: 90
            sizeVariation: 5
            acceleration: PointDirection { y: 0; yVariation: 20; x: 0; xVariation: 20; }
            velocity: AngleDirection { angle: 180; magnitude: 40; angleVariation:150; magnitudeVariation: 20 }
        }
    }

    SpriteSequence{
        id: cogsSprite
        width: 120;
        height: 150;
        z: 18


        sprites:[
            Sprite{
              name: "stillCogsSprite"
              source: "left-cogs-spritesheet.png"

              frameWidth: 165;
              frameHeight: 200
              frameX: 0
              frameY: 0
              frameCount: 1
              frameDuration: 30
            },

            Sprite {
                name: "leftCogsSprite"

                source: "left-cogs-spritesheet.png"

                frameWidth: 165;
                frameHeight: 200
                frameX: 0
                frameY: 0
                frameCount: 90
                frameDuration: _ROTATION_ANIMATION_DURATION / (2*frameCount)
                to:{
                    "leftCogsSprite2":1
                }

            },
            Sprite {
                name: "leftCogsSprite2"

                source: "left-cogs-spritesheet.png"

                frameWidth: 165;
                frameHeight: 200
                frameX: 0
                frameY: 0
                frameCount: 90
                frameDuration: _ROTATION_ANIMATION_DURATION / (2*frameCount)
                to:{
                    "stillCogsSprite":1
                }

            },

            Sprite {
                name: "rightCogsSprite"

                source: "left-cogs-spritesheet.png"

                frameWidth: 165;
                frameHeight: 200
                frameX: 0
                frameY: 0
                frameCount: 90
                reverse: true
                frameDuration: _ROTATION_ANIMATION_DURATION / (2*frameCount)

                to:{
                    "rightCogsSprite2":1
                }
            },
            Sprite {
                name: "rightCogsSprite2"

                source: "left-cogs-spritesheet.png"

                frameWidth: 165;
                frameHeight: 200
                frameX: 0
                frameY: 0
                frameCount: 90
                reverse: true
                frameDuration: _ROTATION_ANIMATION_DURATION / (2*frameCount)

                to:{
                    "stillCogsSprite":1
                }
            }

        ]

    }
}
