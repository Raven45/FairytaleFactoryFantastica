import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Particles 2.0

Rectangle {
    id: tbar_rec
    width: 200
    height: 200
    color: "transparent"

    property int pentago_quad
    property int tbar_rotate_angle

    /*ParticleSystem {
        width: 1; height: 1
        anchors.bottom: tbar.bottom
        anchors.horizontalCenter: tbar.horizontalCenter

        ImageParticle {
            groups: ["boardSmoke"]
            source: "qrc:///particleresources/glowdot.png"
            color: "#111111"
            blueVariation: 0.05
        }

        Emitter {
            anchors.fill: parent
            group: "boardSmoke"
            emitRate: 500
            lifeSpan: 400
            lifeSpanVariation:200
            size: 20
            endSize: 2
            sizeVariation: 5
            acceleration: PointDirection {y: 500; yVariation: 70; x: 0; xVariation: 0;}
            velocity: AngleDirection { angle: 270 + tbar_rotate_angle; magnitude: 500; angleVariation:40; magnitudeVariation: 100 }
        }
    }*/


    Image {
        id: tbar
        source: "tbar.png"
        anchors.centerIn: tbar_rec
        width: 115; height: 120
        rotation: tbar_rec.tbar_rotate_angle
        z: 18

        RedRotateButton {
            id: rotate_clockwise
            direction_string: "clockwise"
            anchors.left: tbar.left
            anchors.leftMargin: -53
            anchors.top: tbar.top
            anchors.topMargin: -53

            quadToRo: tbar_rec.pentago_quad
            roDir: 0
        }

        RedRotateButton {
            id: rotate_counter
            direction_string: "counter"
            anchors.left: tbar.left
            anchors.leftMargin: 50
            anchors.top: tbar.top
            anchors.topMargin: -53

            quadToRo: tbar_rec.pentago_quad
            roDir: 1
        }
    }


}

