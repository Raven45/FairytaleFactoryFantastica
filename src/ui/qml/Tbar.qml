import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: tbar_rec
    width: 200
    height: 200
    color: "transparent"

    property int pentago_quad
    property int tbar_rotate_angle

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

