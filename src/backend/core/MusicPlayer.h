#ifndef MUSICPLAYER_H
#define MUSICPLAYER_H

#include <QMediaPlayer>

class MusicPlayer : public QObject {

    Q_OBJECT

public:

    //set and play the given media file
    void playFile(const QString& filePath){
        mediaPlayer.setMedia(QUrl::fromLocalFile(filePath));
        mediaPlayer.play();
    }

    void togglePlayback(){
        if (mediaPlayer.mediaStatus() == QMediaPlayer::NoMedia)
            //error, there is no file set in the player
            ;
        else if (mediaPlayer.state() == QMediaPlayer::PlayingState)
            mediaPlayer.pause();
        else
            mediaPlayer.play();
    }

    //stop a running media file
    void stop(){
        mediaPlayer.stop();
    }

    //resume or play a media file set in the player
    void play(){
        mediaPlayer.play();
    }

    //change the volume of the player
    void changeVolume(int volume){
        mediaPlayer.volumeChanged(volume);
    }

    //set the player with the given media file, does not play the file
    void setFile(const QString& filePath){
        mediaPlayer.setMedia(QUrl::fromLocalFile(filePath));
    }

private:
    QMediaPlayer mediaPlayer;
};

#endif // MUSICPLAYER_H
