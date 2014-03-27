import QtQuick 2.0

Rectangle {

    width: 171
    height: 98
    color: "transparent"

    z:35
    x: _CLAW_X_HOME
    y: _CLAW_Y_HOME + _CLAW_HOUSE_Y_OFFSET

    Image{
        id: clawHouseImg
        width: 171
        height: 98

        z:35
        anchors.left: parent.left
        anchors.leftMargin: _CLAW_HOUSE_X_OFFSET
        source: "clawHouse.png"


    }

    Image{
        id: leftMessyGear
        z:36
        source: "messyGear.png"
        anchors.horizontalCenter: clawHouseImg.horizontalCenter
        anchors.horizontalCenterOffset: -60 * scale
        anchors.verticalCenter: clawHouseImg.verticalCenter

    }

    Image{
        id: rightMessyGear
        z:36
        source: "messyGear.png"
        anchors.horizontalCenter: clawHouseImg.horizontalCenter
        anchors.horizontalCenterOffset:( 60) * scale
        anchors.verticalCenter: clawHouseImg.verticalCenter
    }

    Connections{
        target: page
        onClawMovingUp:{
            gearsPullingClawUp.start()
        }

        onClawMovingDown:{
            gearsPullingClawDown.start()
        }

        onFinishedClawMovingY:{
            gearsPullingClawDown.stop()
            gearsPullingClawUp.stop()
        }
    }

    ParallelAnimation {
        id: gearsPullingClawUp
        loops: Animation.Infinite
        alwaysRunToEnd: false
        running: false

        NumberAnimation{
            target: rightMessyGear;
            properties: "rotation";
            from: rotation
            to: rotation + 360
            duration: 500
        }

        NumberAnimation{
            target: leftMessyGear;
            properties: "rotation";
            from: rotation
            to: rotation - 360
            duration: 500
        }
    }

    ParallelAnimation {
        id: gearsPullingClawDown
        loops: Animation.Infinite
        alwaysRunToEnd: false
        running: false

        NumberAnimation{
            target: rightMessyGear;
            properties: "rotation";
            from: rotation
            to: rotation - 360
            duration: 500
        }

        NumberAnimation{
            target: leftMessyGear;
            properties: "rotation";
            from: rotation
            to: rotation + 360
            duration: 500
        }
    }
}
