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
        id: playMonkeysSpinningMonkeys
        source: "MonkeysSpinningMonkeys.mp3"
        onStatusChanged: {
            if (playMonkeysSpinningMonkeys.status == Audio.EndOfMedia){
                playMonkeysSpinningMonkeys.stop();
                playMonkeysSpinningMonkeys.play();
            }
        }
    }

    function togglePlayback(){
        if (playMonkeysSpinningMonkeys.playbackState == playMonkeysSpinningMonkeys.PlayingState){
            playMonkeysSpinningMonkeys.pause();
        }
        else
            playMonkeysSpinningMonkeys.play();
    }

    function changeVolume(volumeLevel){
        playMonkeysSpinningMonkeys.volume = volumeLevel;
    }
}
