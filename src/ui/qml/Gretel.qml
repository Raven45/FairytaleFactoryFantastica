import QtQuick 2.0


Rectangle {
    width: 450
    height: 700
    color: "transparent"

    MouseArea{
        anchors.fill: parent
        onClicked:{
            startPickUpGretel()
        }
    }

    Connections{
        target: page
        onClawHasGretel:{
            swingBodyTimer.start()
        }
        onGretelIsOverOven:{
            flail.start()
        }
    }

    Timer{
        id: swingBodyTimer
        interval: 300
        repeat: false
        running: false
        onTriggered:{
            swingBody.start()
        }
    }



    Image{
        id:head
        z: 3
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        source: "Gretel_Happy_Head.png"
    }

    Rectangle{
        id:body
        x: 93
        anchors.horizontalCenterOffset: 18
        anchors.topMargin: -787
        anchors.top: head.bottom
        anchors.horizontalCenter: head.horizontalCenter
        height: 720
        width: 300
        color: "transparent"

        Image{
            height: 600
            z: 1
            width: 300
            anchors.bottom: parent.bottom

            source: "Gretel_Torso.png"

            Rectangle{
                id: leftArm
                x: 4
                y: 169
                width: 150
                height: 150
                color: "transparent"
                z: -1
                rotation: -103


                Image{
                    mirror: true
                    width: 100
                    height: 100
                    anchors.leftMargin: 1
                    anchors.topMargin: 9
                    rotation: 180
                    anchors.left: parent.left
                    anchors.top: parent.top
                    source: "G_Left_Arm.png"

                    Rectangle{
                        id: leftHand
                        width: 100
                        height: 200
                        anchors.left: parent.left
                        anchors.top: parent.top
                        color: "transparent"
                        anchors.leftMargin: -14
                        anchors.topMargin: -84
                        rotation: -17
                        z: -1


                        Image{
                            y: 79
                            width: 100
                            height: 150
                            anchors.leftMargin: 24
                            anchors.topMargin: 91
                            rotation: 0
                            mirror: true
                            anchors.top: parent.top
                            anchors.left: parent.left
                            z: 1
                            source: "G_Left_Hand.png"
                        }
                        SequentialAnimation{
                            id: waveLeftHand
                            running: flail.running
                            loops: Animation.Infinite
                            alwaysRunToEnd: true
                            NumberAnimation {target: leftHand; property: "rotation"; from: 5; to:-17; duration: 70; easing.type: Easing.Linear;}
                            NumberAnimation {target: leftHand; property: "rotation"; from: -17; to: 5; duration: 70; easing.type: Easing.Linear;}
                        }
                    }
                }
            }

            Rectangle{
                id: rightArm
                x: 81
                y: 205
                width: 200
                height: 100
                color: "transparent"
                z: -1

                rotation: -2

                Image{
                    x: 20
                    width: 100
                    height: 100
                    rotation: 0
                    anchors.right: parent.right
                    anchors.top: parent.top
                    source: "G_Right_Arm.png"

                    Rectangle {
                        id: rightHand
                        x: -107
                        y: 25
                        color:"transparent"
                        z: -1
                        rotation: 29
                        height: 100
                        width: 300

                        Image{
                            x: 137
                            height: 100
                            anchors.rightMargin: 13
                            anchors.topMargin: 0
                            rotation: 270
                            mirror: true
                            width: 150
                            anchors.right: parent.right
                            anchors.top: parent.top
                            source: "G_Right_Hand.png"
                        }
                    }

                    SequentialAnimation{
                        id: waveRightHand
                        running: flail.running
                        loops: Animation.Infinite
                        alwaysRunToEnd: true
                        NumberAnimation {target: rightHand; property: "rotation"; from: 29; to: -19; duration: 70; easing.type: Easing.Linear;}
                        NumberAnimation {target: rightHand; property: "rotation"; from: -19; to: 29; duration: 70; easing.type: Easing.Linear;}
                    }
                }
            }
        }

        Image {
            id: pants
            x: -12
            y: 58
            z: -1
            source: "Gretel_Pants.png"

            Image{
                id: leftFoot
                x: 0
                y: 579
                z:-1
                anchors.verticalCenterOffset: 304
                anchors.horizontalCenterOffset: -100
                anchors.centerIn: parent
                source: "G_Left_Foot.png"
            }

            Image {
                id: rightFoot
                x: 178
                y: 579
                z:-1
                anchors.verticalCenterOffset: 304
                anchors.horizontalCenterOffset: 78
                anchors.centerIn: parent
                source: "G_Right_Foot.png"
            }
        }


        SequentialAnimation{
            id: swingBody
            running: false
            alwaysRunToEnd: true
            loops: Animation.Infinite
            ParallelAnimation{
                NumberAnimation {target: body; property: "rotation"; from: 0; to: -30; duration: 600; easing.type: Easing.OutSine;}
                NumberAnimation {target: pants; property: "rotation"; from: 0; to: -30; duration: 600; easing.type: Easing.OutSine;}
            }
            ParallelAnimation{
                NumberAnimation {target: body; property: "rotation"; from: -30; to: 0; duration: 600; easing.type: Easing.InSine;}
                NumberAnimation {target: pants; property: "rotation"; from: -30; to: 0; duration: 600; easing.type: Easing.InSine;}
            }
            ParallelAnimation{
                NumberAnimation {target: body; property: "rotation"; from: 0; to: 30; duration: 600; easing.type: Easing.OutSine;}
                NumberAnimation {target: pants; property: "rotation"; from: 0; to: 30; duration: 600; easing.type: Easing.OutSine;}
            }
            ParallelAnimation{
                NumberAnimation {target: body; property: "rotation"; from: 30; to: 0; duration: 600; easing.type: Easing.InSine;}
                NumberAnimation {target: pants; property: "rotation"; from: 30; to: 0; duration: 600; easing.type: Easing.InSine;}
            }



        }

        ParallelAnimation{
            id: flail
            loops: Animation.Infinite
            running: false
            alwaysRunToEnd: true



            SequentialAnimation {
                id: flailLeftArm
                alwaysRunToEnd: true
                NumberAnimation {target: leftArm; property: "rotation"; from: -103; to: -19; duration: 300; easing.type: Easing.Linear;}
                NumberAnimation {target: leftArm; property: "rotation"; from: -19; to: -103; duration: 300; easing.type: Easing.Linear;}

            }

            SequentialAnimation {
                id: flailRightArm
                alwaysRunToEnd: true
                NumberAnimation {target: rightArm; property: "rotation"; from: 19; to: -41; duration: 300; easing.type: Easing.Linear;}
                NumberAnimation {target: rightArm; property: "rotation"; from: -41; to: 19; duration: 300; easing.type: Easing.Linear;}
            }
        }
    }

}



