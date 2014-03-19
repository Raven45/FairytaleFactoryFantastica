import QtQuick 2.0

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
                else{
                    console.log("ERROR! bad direction received in onTurnCogs")
                }
            }
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
                frameDuration: _ROTATION_ANIMATION_DURATION / frameCount
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
                frameDuration: _ROTATION_ANIMATION_DURATION / frameCount

                to:{
                    "stillCogsSprite":1
                }
            }
        ]

    }
}
