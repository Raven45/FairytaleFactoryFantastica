import QtQuick 2.0


Rectangle {
    width: 450
    height: 700
    color: "transparent"

    MouseArea{
        anchors.fill: parent
        onClicked:{
            startPickUpHansel()
        }
    }

    Connections{
        target: page
        onClawHasHansel:{
            swingBodyTimer.start()
        }
        onHanselIsOverOven:{
            flail.start()
        }
        onClearBoard:{
            head.source = "Hansel_Happy_Head.png";
            flail.stop();
            swingBody.stop();
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
        source: "Hansel_Happy_Head.png"
    }

    Rectangle{
        id:body
        x: 81
        anchors.horizontalCenterOffset: 6
        anchors.topMargin: -369
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

            source: "Hansel_Body.png"

            Rectangle{
                id: leftArm
                x: 27
                y: 195
                width: 150
                height: 150
                color: "transparent"
                z: -1
                rotation: -90


                Image{
                    mirror: true
                    width: 100
                    height: 100
                    anchors.leftMargin: -20
                    anchors.topMargin: 17
                    rotation: 180
                    anchors.left: parent.left
                    anchors.top: parent.top
                    source: "H_Left_Arm.png"

                    Rectangle{
                        id: leftHand
                        width: 100
                        height: 200
                        anchors.left: parent.left
                        anchors.top: parent.top
                        color: "transparent"
                        anchors.leftMargin: -16
                        anchors.topMargin: -15
                        rotation: 4
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
                            source: "H_Left_Hand.png"
                        }
                        SequentialAnimation{
                            id: waveLeftHand
                            running: flail.running
                            loops: Animation.Infinite
                            alwaysRunToEnd: true
                            NumberAnimation {target: leftHand; property: "rotation"; from: 5; to:-35; duration: 70; easing.type: Easing.Linear;}
                            NumberAnimation {target: leftHand; property: "rotation"; from: -35; to: 5; duration: 70; easing.type: Easing.Linear;}
                        }
                    }
                }
            }

            Rectangle{
                id: rightArm
                x: 95
                y: 238
                width: 200
                height: 100
                color: "transparent"
                z: -1

                rotation: 31

                Image{
                    x: 20
                    width: 100
                    height: 100
                    rotation: 0
                    anchors.right: parent.right
                    anchors.top: parent.top
                    source: "H_Right_Arm.png"

                    Rectangle {
                        id: rightHand
                        x: -107
                        y: 51
                        color:"transparent"
                        z: -1
                        rotation: -29
                        height: 100
                        width: 300

                        Image{
                            x: 150
                            height: 100
                            rotation: 0
                            width: 150
                            anchors.right: parent.right
                            anchors.top: parent.top
                            source: "H_Right_Hand.png"
                        }
                    }

                    SequentialAnimation{
                        id: waveRightHand
                        running: flail.running
                        loops: Animation.Infinite
                        alwaysRunToEnd: true
                        NumberAnimation {target: rightHand; property: "rotation"; from: 10; to: -29; duration: 70; easing.type: Easing.Linear;}
                        NumberAnimation {target: rightHand; property: "rotation"; from: -29; to: 10; duration: 70; easing.type: Easing.Linear;}
                    }
                }
            }
        }

        Image {
            id: pants
            x: 52
            y: 339
            z: -1
            source: "Hansel_Pants.png"

            Image{
                id: leftFoot
                x: 0
                y: 316
                z:-1
                anchors.verticalCenterOffset: 198
                anchors.horizontalCenterOffset: -60
                anchors.centerIn: parent
                source: "H_Left_Foot.png"
            }

            Image {
                id: rightFoot
                x: 130
                y: 316
                z:-1
                anchors.verticalCenterOffset: 198
                anchors.horizontalCenterOffset: 70
                anchors.centerIn: parent
                source: "H_Right_Foot.png"
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
                NumberAnimation {target: leftArm; property: "rotation"; from: -90; to: 10; duration: 300; easing.type: Easing.Linear;}
                NumberAnimation {target: leftArm; property: "rotation"; from: 10; to: -90; duration: 300; easing.type: Easing.Linear;}

            }

            SequentialAnimation {
                id: flailRightArm
                alwaysRunToEnd: true
                NumberAnimation {target: rightArm; property: "rotation"; from: 31; to: -74; duration: 300; easing.type: Easing.Linear;}
                NumberAnimation {target: rightArm; property: "rotation"; from: -74; to: 31; duration: 300; easing.type: Easing.Linear;}
            }
        }
    }

}



