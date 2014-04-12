import QtQuick 2.0

Rectangle {
    height: 350
    width: 450

    color: "transparent"

    Image{
        source: "oven.png"
        height: parent.height
        width: parent.width
        mirror: true
        z: parent.z
    }


/*
    SpriteSequence{
        id: leftFireSprites
        height: 512
        width: 512
        z: parent.z + 1
        running: true
        anchors.centerIn: parent
        scale: .92
        anchors.horizontalCenterOffset: -35
        anchors.verticalCenterOffset: -100
        opacity: .7
        sprites:[

            Sprite{
                name: "flameSprite"

                source: "flame.png"
                frameCount: 6
                frameX: 0
                frameY: 0
                frameDuration:45
                frameWidth: 512
                frameHeight: 512
                to:{
                    "flameSprite":1
                }
            }

        ]




    }

    SpriteSequence{
        id: rightFireSprites
        height: 512
        width: 512
        z: parent.z + 1
        running: true
        anchors.centerIn: parent
        scale: .92
        anchors.horizontalCenterOffset: 70
        anchors.verticalCenterOffset: -70
        opacity: .7
        sprites:[

            Sprite{
                name: "flameSprite"

                source: "flame.png"
                frameCount: 6
                frameX: 0
                frameY: 0
                frameDuration:60
                frameWidth: 512
                frameHeight: 512
                to:{
                    "flameSprite":1
                }
            }

        ]




    }

    SpriteSequence{
        id: lowFireSprites
        height: 512
        width: 512
        z: parent.z + 1
        running: true
        anchors.centerIn: parent
        opacity: .7

        sprites:[

            Sprite{
                name: "flameSprite"

                source: "flame.png"
                frameCount: 6
                frameX: 0
                frameY: 0
                frameDuration:40
                frameWidth: 512
                frameHeight: 512
                to:{
                    "flameSprite":1
                }
            }

        ]




    }
    */
}
