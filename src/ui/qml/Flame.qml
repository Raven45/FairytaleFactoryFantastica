import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    height: 60
    width: 150
    color: "transparent"
    id: root

    ParticleSystem {
        height: 40
        width: 150
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        ImageParticle {
            groups: ["flame"]
            source: "qrc:///particleresources/glowdot.png"
            color: "#11ff400f"
            redVariation: .3
        }

        Emitter {
            anchors.fill: parent
            anchors.verticalCenterOffset: 200
            group: "flame"
            shape: EllipseShape {fill:true}
            emitRate: 3000
            lifeSpan: 1600
            lifeSpanVariation:500
            size: 10
            endSize: 2
            sizeVariation: 5
            acceleration: PointDirection {y: -70; yVariation: 20; x: 0; xVariation: 20;}
            velocity: AngleDirection { angle: 270; magnitude: 10; angleVariation:50; magnitudeVariation: 10 }
        }
    }
}
