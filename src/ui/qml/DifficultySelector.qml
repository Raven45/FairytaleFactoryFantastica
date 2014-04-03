import QtQuick 2.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

Rectangle {
    id: difficultySelector
    width: 325
    height: 325
    color: "transparent"

    //witch-head-easy.png
    property string difficulty_selector_string: "easy"
    property string difficulty_image_source: "witch-head-" + difficulty_selector_string + ".png"

    function decreaseDifficulty() {
        if(difficulty_selector_string == "hard" ){
            difficulty_selector_string = "med";
        } else if(difficulty_selector_string == "med") {
            difficulty_selector_string = "easy";
        } else if(difficulty_selector_string == "easy") {
            difficulty_selector_string = "hard";
        } else {}
    }

    function increaseDifficulty() {
        if(difficulty_selector_string == "easy"){
            difficulty_selector_string = "med";
        } else if(difficulty_selector_string == "med") {
            difficulty_selector_string = "hard";
        } else if(difficulty_selector_string == "hard") {
            difficulty_selector_string = "easy";
        } else {}
    }

    SoundEffect {
        id: difficultySelectorSound
        source: "ButtonClick2.wav"
    }

    Image{
        id: difficultySelectorText
        width: 300; height: 40
        z: witchFace.z
        scale: 0.65
        source: {
            if(difficulty_selector_string == "easy") {
                "easy-text.png"
            } else if (difficulty_selector_string == "med"){
                "medium-text.png"
            } else {
                "hard-text.png"
            }
        }

        anchors.top: witchFace.bottom
        anchors.topMargin: -80
        anchors.horizontalCenter: difficultySelector.horizontalCenter
    }

    Image{
        id: witchFace
        width: 325; height: 325
        z: difficultySelector.z + 1
        source: difficulty_image_source
        scale: 0.5

        anchors.horizontalCenter: difficultySelector.horizontalCenter
        anchors.verticalCenter: difficultySelector.verticalCenter

        MouseArea {
            id: witchFace_mouseArea
            anchors.fill: parent

            onPressed: { if(_SOUND_CHECK_FLAG) difficultySelectorSound.play(); }
            onClicked: { increaseDifficulty(); }
        }
    }

    Item{
        id: difficultyLeftSelector
        width: difficulty_leftSelector_img.width
        height: difficulty_leftSelector_img.height
        anchors.left: difficultySelector.left
        anchors.verticalCenter: difficultySelector.verticalCenter

        Glow {
           id: difficulty_leftSelector_glowEffect
           anchors.fill: difficulty_leftSelector_img
           radius: 8
           samples: 24
           spread: 0.5
           color: "#58d6ff"
           source: difficulty_leftSelector_img
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: difficulty_leftSelector_img
            width:50; height: 50
            source: "left-selector.png"

            MouseArea {
                id: difficulty_leftSelector_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(difficulty_leftSelector_glowEffect.visible == false && difficulty_leftSelector_mouseArea.containsMouse){
                        difficulty_leftSelector_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(difficulty_leftSelector_glowEffect.visible == true){
                        difficulty_leftSelector_glowEffect.visible = false;
                    }
                }
                onPressed: { if(_SOUND_CHECK_FLAG) difficultySelectorSound.play() }
                onClicked: { decreaseDifficulty(); }
            }
        }
    }

    Item{
    id: difficultyRightSelector
    width: difficulty_rightSelector_img.width
    height: difficulty_rightSelector_img.height
    anchors.right: difficultySelector.right
    anchors.verticalCenter: difficultySelector.verticalCenter

        Glow {
           id: difficulty_rightSelector_glowEffect
           anchors.fill: difficulty_rightSelector_img
           radius: 8
           samples: 24
           spread: 0.5
           color: "#58d6ff"
           source: difficulty_rightSelector_img
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: difficulty_rightSelector_img
            width:50; height: 50
            source: "right-selector.png"

            MouseArea {
                id: difficulty_rightSelector_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(difficulty_rightSelector_glowEffect.visible == false && difficulty_rightSelector_mouseArea.containsMouse){
                        difficulty_rightSelector_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(difficulty_rightSelector_glowEffect.visible == true){
                        difficulty_rightSelector_glowEffect.visible = false;
                    }
                }
                onPressed: { if(_SOUND_CHECK_FLAG) difficultySelectorSound.play(); }
                onClicked: { increaseDifficulty(); }
            }
        }
    }

}
