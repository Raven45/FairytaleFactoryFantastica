import QtQuick 2.0
import QtQuick.Particles 2.0
import QtMultimedia 5.0

Rectangle {
    height: 60
    width: 150
    color: "transparent"
    id: root

    SoundEffect {
         id: flameSound
         source: "small-fireball.wav"
    }

    ParticleSystem {
        height: 40
        width: 150
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        ImageParticle {
            id: fireParticle
            groups: ["flame"]
            source: "qrc:///particleresources/glowdot.png"
            state: "NORMAL"
            redVariation: .3

            states:[
                State{
                    name: "NORMAL"
                    PropertyChanges{
                        target: fireParticle
                        color: "#11ff400f"
                        redVariation: .3
                    }
                },
                State{
                    name: "WITCH_FIRE"
                    PropertyChanges{
                        target: fireParticle
                        color: "#880E8200"
                    }
                }

            ]

            transitions:[
                Transition{
                    from: "NORMAL"
                    to: "WITCH_FIRE"
                    ColorAnimation{ duration: 700 }
                },
                Transition{
                    from: "WITCH_FIRE"
                    to: "NORMAL"
                    ColorAnimation{ duration: 1900 }
                }
            ]
        }

        Emitter {
            id: fire
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

            Timer{
                id: witchFireTimer
                interval: 1800
                running: false
                repeat: false
                onTriggered:{
                    fireParticle.state = "WITCH_FIRE";
                }
            }

            Connections{
                target: page

                onWitchIsOverOven:{
                    witchFireTimer.start()
                }

                onDroppedSomethingInOven:{
                    startSoundTimer.start()
                    startFirePlume.start()
                }
            }

            SequentialAnimation{
                id: startFirePlume
                running: true
                property int startDuration: 400


                ScriptAction { script:calmFlameTimer.start() }
                NumberAnimation{ target: dummy; properties: "opacity"; to: 0; duration: 400 }
                ParallelAnimation{
                    NumberAnimation{ target: fire.velocity; properties: "magnitude"; to: 1000; duration: startDuration }
                    NumberAnimation{ target: fire.velocity; properties: "magnitudeVariation"; to: 200; duration: startDuration }
                    NumberAnimation{ target: fire.velocity; properties: "angleVariation"; to: 20; duration: startDuration }
                    NumberAnimation{ target: fire.acceleration; properties: "y"; to: 900; duration: 100 }
                    NumberAnimation{ target: fire.acceleration; properties: "yVariation"; to: 100; duration: startDuration }
                    //NumberAnimation{ target: fire.acceleration; properties: "xVariation"; to: 400; duration: startDuration }
                    NumberAnimation{ target: fire; properties: "size"; to: 65; duration: 400 }
                    NumberAnimation{ target: fire; properties: "lifeSpan"; to: 2000; duration: startDuration }
                }

            }

            SequentialAnimation{
                id: endFirePlume
                running: false
                property int startDuration: 400

                //NumberAnimation{ target: dummy; properties: "opacity"; to: 0; duration: 1000 }
                NumberAnimation{ target: fire.velocity; properties: "magnitude"; to: 10; duration: 200 }

                ParallelAnimation{


                    NumberAnimation{ target: fire.velocity; properties: "magnitudeVariation"; to: 10; duration: startDuration }
                    NumberAnimation{ target: fire.velocity; properties: "angleVariation"; to: 50; duration: startDuration }

                    NumberAnimation{ target: fire.acceleration; properties: "yVariation"; to: 20; duration: startDuration }
                    //NumberAnimation{ target: fire.acceleration; properties: "xVariation"; to: 20; duration: startDuration }

                }
                NumberAnimation{ target: fire.acceleration; properties: "y"; to: -70; duration: startDuration }
                NumberAnimation{ target: fire; properties: "size"; to: 10; duration: startDuration }
                NumberAnimation{ target: fire; properties: "lifeSpan"; to: 1600; duration: startDuration }
                ScriptAction{ script: {fireParticle.state = "NORMAL"; animationOverTimer.start();} }


             }

             Rectangle{id: dummy; color:"transparent"; visible: false; }

            Timer{
                id: animationOverTimer

                property bool isFirstTime: true
                interval: 2200
                running: false
                repeat: false

                onTriggered:{
                    if( !isFirstTime ){
                        doneWithFireAnimation();

                    }
                    else{
                        isFirstTime = false;
                    }
                }
            }

            Timer{
                id: calmFlameTimer
                interval: 1200
                running: false
                repeat: false

                onTriggered:{
                    endFirePlume.start()
                }
            }

            Timer {
                 id: startSoundTimer
                 interval: 400
                 running: false
                 repeat: false
                 onTriggered: if(_SOUND_CHECK_FLAG) flameSound.play()
            }

        }
    }
}
