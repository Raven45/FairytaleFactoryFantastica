import QtQuick 2.0

SpriteSequence {

    property bool reverseBelt: false

    width: 375
    height: 150
    scale: 0.65
    running: true
    rotation: reverseBelt? -15 : 15
    //interpolate: true

    sprites:[

        Sprite{
            name: "belt"

            source: "line8.png"
            frameHeight: 200
            frameWidth: 500
            frameCount: 8
            frameX: 0
            frameY: 0
            reverse: reverseBelt
            to:{
                "belt":1
            }
        }
    ]
}
