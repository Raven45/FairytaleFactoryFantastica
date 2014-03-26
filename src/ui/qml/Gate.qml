import QtQuick 2.0

SpriteSequence {

    width: 1120
    height: 1800
    running: true
    //interpolate: true

    sprites:[

        Sprite{
            name: "gate"
            frameHeight: 200
            frameWidth: 500
            frameCount: 8
            frameX: 0
            frameY: 0
            to:{
                "belt":1
            }
        }
    ]
}
