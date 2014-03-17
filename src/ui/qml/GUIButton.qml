import QtQuick 2.0

Rectangle {
    width: 100; height: 100
    color: "transparent"

    property var source_string

    Image {
        id: normal
        width: 100; height: 100
        anchors.centerIn: parent
        source: source_string
        smooth: true
        opacity: 1

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
        }

        states:
            State {
                name: "mouse-over"; when: mouseArea.containsMouse
                PropertyChanges { target: normal; opacity: 0}
                PropertyChanges { target: inverse; opacity: 1}
        }

        transitions: Transition {
            NumberAnimation { properties: "scale, opacity"; easing.type: Easing.InOutQuad; duration: 1000  }
        }
    }

    Image {
        id: inverse
        source: "inverse-" + source_string
        smooth: true
        opacity: 0
        anchors.fill: normal
    }

}
