import QtQuick 2.0
import QtMultimedia 5.0

Item {

    Connections{
        target: page
        onChangeSoundState: {
            if(_SOUND_CHECK_FLAG) {
                changeVolume(0);
            } else {
                changeVolume(1);
            }
        }
    }


    Audio {
        id: scaryMusic
        source: "OppressiveGloom.mp3"
        loops: Audio.Infinite
        volume: .75
    }

    property bool isScary: true

    Audio {
        id: happyMusic
        source: "MonkeysSpinningMonkeys.mp3"
        loops: Audio.Infinite
    }

    function switchAudioFile(){
        if( isScary ){
            scaryMusic.stop();
            happyMusic.play();
            isScary = false;
        }
        else {
            scaryMusic.stop();
            happyMusic.play();
            isScary = true;
        }
    }

    function togglePlayback() {

        console.log("in togglePlayback, isScary = " + isScary );

        if( isScary ) {
            if (scaryMusic.playbackState == scaryMusic.PlayingState){
                scaryMusic.pause();
            }
            else {
                scaryMusic.play();
            }
        }
        else{
            if (happyMusic.playbackState == happyMusic.PlayingState){
                happyMusic.pause();
            }
            else {
                happyMusic.play();
            }
        }
    }

    function changeVolume(volumeLevel){
        scaryMusic.volume = volumeLevel;
        happyMusic.volume = volumeLevel;
    }
}
