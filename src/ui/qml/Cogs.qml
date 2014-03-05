import QtQuick 2.0

Item {

    property int quadrantsToOperateOn

    Connections{
        target: pentagoBoard
        onTurnCogs:{
            cogsSprite.jumpTo()
            //if-else depending on something
        }
    }

    SpriteSequence{
        id: cogsSprite
        width: 165;
        height: 200;
        z: 0;
        sprites:[
            Sprite {
                name: "leftCogsSprite"

                source: "left-cogs-spritesheet.png"

                frameWidth: 165;
                frameHeight: 200
                frameX: 0
                frameY: 0
                frameCount: 90
                duration: _ROTATION_ANIMATION_DURATION
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
                duration: _ROTATION_ANIMATION_DURATION
            }
        ]

    }
}
