import QtQuick 2.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

Rectangle {
    id: characterSelector
    width: 325
    height: 325
    color: "transparent"

    property string character_selector_string: "hansel"
    property string character_image_source: character_selector_string + "-head.png"
    property bool overrideDefault: false
    signal characterChangeClicked
    function changeCharacter() {
        if(character_selector_string == "hansel"){
            character_selector_string = "gretel";
        } else {
            character_selector_string = "hansel";
        }
    }

    onCharacterChangeClicked: {
        if( !overrideDefault ){
            changeCharacter();
        }
    }

    SoundEffect {
        id: selectorSound
        source: "ButtonClick2.wav"
    }

    Image{
        id: characterSelectorText
        width: 300; height: 40
        z: characterFace.z
        scale: 0.65
        source: character_selector_string == "hansel" ? "hansel-text.png" : "gretel-text.png"

        anchors.top: characterFace.bottom
        anchors.topMargin: -95
        anchors.horizontalCenter: characterSelector.horizontalCenter
    }

    Image{
        id: characterFace
        width: 325; height: 325
        z: characterSelector.z + 1
        source: character_image_source
        scale: 0.5

        anchors.horizontalCenter: characterSelector.horizontalCenter
        anchors.verticalCenter: characterSelector.verticalCenter

        MouseArea {
            id: characterFace_mouseArea
            anchors.fill: parent

            onPressed: { if(_SOUND_CHECK_FLAG && !forkliftMenuButtonsAreLocked ) selectorSound.play() }
            onClicked: { if( !forkliftMenuButtonsAreLocked ) characterChangeClicked(); }
        }
    }

    Item{
        id: leftSelector
        width: leftSelector_img.width
        height: leftSelector_img.height
        anchors.left: characterSelector.left
        anchors.verticalCenter: characterSelector.verticalCenter

        Glow {
           id: leftSelector_glowEffect
           anchors.fill: leftSelector_img
           radius: 8
           samples: 24
           spread: 0.5
           color: "#58d6ff"
           source: leftSelector_img
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: leftSelector_img
            width:50; height: 50
            source: "left-selector.png"

            MouseArea {
                id: leftSelector_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(leftSelector_glowEffect.visible == false && leftSelector_mouseArea.containsMouse && !forkliftMenuButtonsAreLocked ){
                        leftSelector_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(leftSelector_glowEffect.visible == true && !forkliftMenuButtonsAreLocked ){
                        leftSelector_glowEffect.visible = false;
                    }
                }
                onPressed: { if(_SOUND_CHECK_FLAG && !forkliftMenuButtonsAreLocked ) selectorSound.play() }
                onClicked: { if( !forkliftMenuButtonsAreLocked ) characterChangeClicked(); }
            }
        }
    }

    Item{
    id: rightSelector
    width: rightSelector_img.width
    height: rightSelector_img.height
    anchors.right: characterSelector.right
    anchors.verticalCenter: characterSelector.verticalCenter

        Glow {
           id: rightSelector_glowEffect
           anchors.fill: rightSelector_img
           radius: 8
           samples: 24
           spread: 0.5
           color: "#58d6ff"
           source: rightSelector_img
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: rightSelector_img
            width:50; height: 50
            source: "right-selector.png"

            MouseArea {
                id: rightSelector_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(rightSelector_glowEffect.visible == false && rightSelector_mouseArea.containsMouse && !forkliftMenuButtonsAreLocked ){
                        rightSelector_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(rightSelector_glowEffect.visible == true){
                        rightSelector_glowEffect.visible = false;
                    }
                }
                onPressed: { if(_SOUND_CHECK_FLAG && !forkliftMenuButtonsAreLocked ) selectorSound.play(); }
                onClicked: { if( !forkliftMenuButtonsAreLocked ) characterChangeClicked(); }
            }
        }
    }

}
