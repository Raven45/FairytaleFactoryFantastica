import QtQuick 2.0


Rectangle {
    width: 450
    height: 700
    color: "transparent"

    MouseArea{
        anchors.fill: parent
        onClicked:{
            startPickUpWitch()
        }
    }

    Connections{
        target: page
        onClawHasWitch:{
            swingBodyTimer.start();
            head.source = "Angry_Witch.png";
        }
        onWitchIsOverOven:{
            flail.start();
            head.source = "Angry_Witch_Scared.png";

        }
        onClearBoard:{
            head.source = "Witch_Head.png";
            flail.stop()
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
        x: 150
        anchors.horizontalCenterOffset: 0
        anchors.topMargin: 8
        sourceSize.height: 150
        sourceSize.width: 150
        z: 3
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        source: "Witch_Head.png"
    }

    Rectangle{
        id:body
        x: 68
        anchors.horizontalCenterOffset: -7
        anchors.topMargin: -368
        anchors.top: head.bottom
        anchors.horizontalCenter: head.horizontalCenter
        height: 623
        width: 300
        color: "transparent"

        Image{
            x: -34
            y: 392
            height: 400
            anchors.bottomMargin: -14
            z: 1
            width: 324
            anchors.bottom: parent.bottom

            source: "Witch_Torso.png"


            Image{
                id: leftArm
                anchors.leftMargin: 78
                anchors.topMargin: -23
                anchors.left: parent.left
                anchors.top: parent.top
                source: "Witch_Left_Arm.png"

                Image{
                    id: leftHand
                    y: 79
                    anchors.leftMargin: 8
                    anchors.topMargin: 209
                    rotation: 0
                    anchors.top: parent.top
                    anchors.left: parent.left
                    z: -1
                    source: "Witch_Hand.png"
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





            Image{
                id: rightArm
                x: 206
                anchors.rightMargin: 27
                anchors.topMargin: 41
                rotation: 0
                anchors.right: parent.right
                anchors.top: parent.top
                source: "Witch_Right_Arm.png"

                Image {
                id: rightHand
                x: 38
                rotation: -16
                z: -1
                mirror: true
                anchors.rightMargin: 11
                anchors.topMargin: 161
                    anchors.right: parent.right
                    anchors.top: parent.top
                    source: "Witch_Hand.png"
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

        Image {
            id: pants
            x: -31
            y: 186
            width: 318
            height: 421
            rotation: 0
            z: -1
            source: "Witch_Pants.png"


        }

        Image{
            id: leftFoot
            x: -56
            y: 131
            z:-2
            anchors.verticalCenterOffset: 69
            anchors.horizontalCenterOffset: -6
            anchors.centerIn: parent
            source: "Witch_Boots.png"
        }


        SequentialAnimation{
            id: swingBody
            running: false
            alwaysRunToEnd: true
            loops: Animation.Infinite
            ParallelAnimation{
                NumberAnimation {target: body; property: "rotation"; from: 0; to: -30; duration: 500; easing.type: Easing.OutSine;}
                NumberAnimation {target: pants; property: "rotation"; from: 0; to: -25; duration: 500; easing.type: Easing.OutSine;}
            }
            ParallelAnimation{
                NumberAnimation {target: body; property: "rotation"; from: -30; to: 0; duration: 500; easing.type: Easing.InSine;}
                NumberAnimation {target: pants; property: "rotation"; from: -25; to: 0; duration: 500; easing.type: Easing.InSine;}
            }
            ParallelAnimation{
                NumberAnimation {target: body; property: "rotation"; from: 0; to: 30; duration: 500; easing.type: Easing.OutSine;}
                NumberAnimation {target: pants; property: "rotation"; from: 0; to: 25; duration: 500; easing.type: Easing.OutSine;}
            }
            ParallelAnimation{
                NumberAnimation {target: body; property: "rotation"; from: 30; to: 0; duration: 500; easing.type: Easing.InSine;}
                NumberAnimation {target: pants; property: "rotation"; from: 25; to: 0; duration: 500; easing.type: Easing.InSine;}
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
                NumberAnimation {target: leftArm; property: "rotation"; from: 0; to: 120; duration: 300; easing.type: Easing.Linear;}
                NumberAnimation {target: leftArm; property: "rotation"; from: 120; to: 0; duration: 300; easing.type: Easing.Linear;}

            }

            SequentialAnimation {
                id: flailRightArm
                alwaysRunToEnd: true
                NumberAnimation {target: rightArm; property: "rotation"; from: 0; to: -120; duration: 300; easing.type: Easing.Linear;}
                NumberAnimation {target: rightArm; property: "rotation"; from: -120; to: 0; duration: 300; easing.type: Easing.Linear;}
            }
        }
    }

}



