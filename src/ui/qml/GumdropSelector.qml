import QtQuick 2.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

Rectangle {
    id: gumdropSelector
    width: 325
    height: 325
    color: "transparent"

    property string gumdrop_selector_string: "purp"
    property string gumdrop_image_source: gumdrop_selector_string + "-gumdrop-centered.png"

    function changeGumdrop() {
        if(gumdrop_selector_string == "purp"){
            gumdrop_selector_string = "teal";
        } else {
            gumdrop_selector_string = "purp";
        }
    }

    SoundEffect {
        id: gumdropSelectorSound
        source: "ButtonClick2.wav"
    }

    Image{
        id: gumdropSelectorText
        width: 300; height: 40
        z: gumdropSelectorImage.z
        scale: 0.65
        source: gumdrop_selector_string == "purp" ? "second-text.png" : "first-text.png"

        anchors.top: gumdropSelectorImage.bottom
        anchors.topMargin: -35
        anchors.horizontalCenter: gumdropSelector.horizontalCenter
    }

    Image{
        id: gumdropSelectorImage
        width: 150; height: 150
        z: gumdropSelector.z + 1
        source: gumdrop_image_source

        anchors.horizontalCenter: gumdropSelector.horizontalCenter
        anchors.verticalCenter: gumdropSelector.verticalCenter

        MouseArea {
            id: gumdropSelectorImage_mouseArea
            anchors.fill: parent

            onPressed: { if(_SOUND_CHECK_FLAG) gumdropSelectorSound.play() }
            onClicked: { changeGumdrop(); }
        }
    }

    Item{
        id: gumdropLeftSelector
        width: gumdrop_leftSelector_img.width
        height: gumdrop_leftSelector_img.height
        anchors.left: gumdropSelector.left
        anchors.verticalCenter: gumdropSelector.verticalCenter

        Glow {
           id: gumdrop_leftSelector_glowEffect
           anchors.fill: gumdrop_leftSelector_img
           radius: 16
           samples: 24
           spread: 0.8
           color: "#58d6ff"
           source: gumdrop_leftSelector_img
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: gumdrop_leftSelector_img
            width:50; height: 50
            source: "left-selector.png"

            MouseArea {
                id: gumdrop_leftSelector_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(gumdrop_leftSelector_glowEffect.visible == false && gumdrop_leftSelector_mouseArea.containsMouse){
                        gumdrop_leftSelector_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(gumdrop_leftSelector_glowEffect.visible == true){
                        gumdrop_leftSelector_glowEffect.visible = false;
                    }
                }
                onPressed: { if(_SOUND_CHECK_FLAG) gumdropSelectorSound.play() }
                onClicked: { changeGumdrop(); }
            }
        }
    }

    Item{
    id: gumdropRightSelector
    width: gumdrop_rightSelector_img.width
    height: gumdrop_rightSelector_img.height
    anchors.right: gumdropSelector.right
    anchors.verticalCenter: gumdropSelector.verticalCenter

        Glow {
           id: gumdrop_rightSelector_glowEffect
           anchors.fill: gumdrop_rightSelector_img
           radius: 16
           samples: 24
           spread: 0.8
           color: "#58d6ff"
           source: gumdrop_rightSelector_img
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: gumdrop_rightSelector_img
            width:50; height: 50
            source: "right-selector.png"

            MouseArea {
                id: gumdrop_rightSelector_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(gumdrop_rightSelector_glowEffect.visible == false && gumdrop_rightSelector_mouseArea.containsMouse){
                        gumdrop_rightSelector_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(gumdrop_rightSelector_glowEffect.visible == true){
                        gumdrop_rightSelector_glowEffect.visible = false;
                    }
                }
                onPressed: { if(_SOUND_CHECK_FLAG) gumdropSelectorSound.play(); }
                onClicked: { changeGumdrop(); }
            }
        }
    }

}
