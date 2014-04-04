import QtQuick 2.0
Rectangle {
    width: 100; height: 100
    color: "transparent"

    property var source_string
    property string stencil_string
    property bool hasInverse: true

    Image {
        id: stencil_text
        width: 200; height: 40
        scale: 0.5
        source: stencil_string
        opacity: 0
        anchors.top: parent.bottom
        anchors.topMargin: -22
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 1
    }

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
                name: "mouse-over";
                when: mouseArea.containsMouse && hasInverse;
                PropertyChanges { target: normal; opacity: 0}
                PropertyChanges { target: inverse; opacity: 1}
                PropertyChanges { target: stencil_text; opacity: 1}
        }

        transitions: Transition {
            NumberAnimation { properties: "scale, opacity"; easing.type: Easing.InOutQuad; duration: 1000  }
        }
    }

    Image {
        id: inverse
        source: hasInverse? "inverse-" + source_string : "";
        smooth: true
        opacity: 0
        anchors.fill: normal
    }

}
