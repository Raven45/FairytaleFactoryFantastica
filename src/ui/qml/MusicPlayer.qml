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
        id: musicFile
        source: "OppressiveGloom.mp3"
        loops: Audio.Infinite
    }

//    Audio {
//        id: musicFile
//        source: "MonkeysSpinningMonkeys.mp3"
//        loops: Audio.Infinite
//    }

    function switchAudioFile(){
        musicFile.stop();
        if (musicFile.source == "OppressiveGloom.mp3"){
            musicFile.source = "MonkeysSpinningMonkeys.mp3"
        }
        else{
            musicFile.source = "MonkeysSpinningMonkeys.mp3"
        }
        musicFile.play();
    }

    function togglePlayback(){
        if (musicFile.playbackState == musicFile.PlayingState){
            musicFile.pause();
        }
        else
            musicFile.play();
    }

    function changeVolume(volumeLevel){
        musicFile.volume = volumeLevel;
    }
}
