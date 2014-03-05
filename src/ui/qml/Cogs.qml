import QtQuick 2.0

Item {
    AnimatedSprite {
        id: cogsSprite
        width: 165; height: 200; z: 0
        source: "left-cogs-spritesheet.png"

        frameWidth: 165; frameHeight: 200
        frameCount: 90
        frameDuration: 5

        loops: 1
        running: false
        reverse: false
    }
}
