import QtQuick 2.0
import QtMultimedia 5.0

Item {
    Audio {
        id: playMonkeysSpinningMonkeys
        source: "MonkeysSpinningMonkeys.mp3"
        loops: Audio.Infinite
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
