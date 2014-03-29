import QtQuick 2.0
import QtMultimedia 5.0

Item {
    id: gumdropknob

    property int volume_level: 1
    property string base_knob_source: "knob-" + volume_level + ".png";

    onVolume_levelChanged: {
        pieceFlowIntensityChanged( volume_level)
    }

    width: 85; height: 85; z: top_tubes.z + 1
    anchors.top: gameScreen.top
    anchors.topMargin: 63
    anchors.left: parent.left
    anchors.leftMargin: parent.width/2 - (gumdropknob.width/2) - 3

    SoundEffect {
        id: volUpSound
        source: "gumdrop-vol-up.wav"
    }

    SoundEffect {
        id: volDownSound
        source: "gumdrop-vol-down.wav"
    }

    Image {
        id: base_knob
        width: 85; height: 85; z: top_tubes.z + 1
        anchors.centerIn: gumdropknob

        source: base_knob_source

        fillMode: Image.PreserveAspectFit
        visible: true

        Image {
            id: volume_knob
            width: 60; height: 60; z: base_knob.z + 1
            rotation: 0
            anchors.centerIn: base_knob

            source: "knob.png"

            fillMode: Image.PreserveAspectFit
            visible: true

            MouseArea {
                id: volume_knob_mouseArea
                anchors.fill: volume_knob
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onPressed: {
                    if (_SOUND_CHECK_FLAG && mouse.button == Qt.RightButton) {
                        volDownSound.play();
                    } else if (_SOUND_CHECK_FLAG && mouse.button == Qt.LeftButton) {
                        volUpSound.play();
                    }
                }

                onClicked: {
                    if (mouse.button == Qt.RightButton) {
                        if(gumdropknob.volume_level > 1) {
                            volume_knob.rotation -= 55;
                            --gumdropknob.volume_level;

                        }
                    } else if (mouse.button == Qt.LeftButton) {
                        if(gumdropknob.volume_level < 5) {
                            ++gumdropknob.volume_level;
                            volume_knob.rotation += 55;
                        }
                    }
                }
            }
        }
    }

}
