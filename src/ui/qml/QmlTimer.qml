
// QmlTimer.qml
import QtQuick 2.0

Item {
    id: root
    opacity: 0.0

    property int duration: 0
    property bool timerActive: false

    signal triggered()

    function startTimer() {
        if (duration == 0) {
            console.log("timer can't start when duration is 0");
            return;
        }

        if (timerActive == true) {
            console.log("timer is already active, not starting");
            return;
        }

        opacity = 0;
        timerActive = true;
        timerAnimation.start();
    }

    function stopTimer() {
        timerActive = false;
        timerAnimation.stop();
    }



    NumberAnimation on opacity{
        id: timerAnimation
        from: 0
        to: 1
        duration: root.duration
    }





    onOpacityChanged: {
        if (timerActive == true && root.opacity === 1) {
            timerActive = false;
            root.triggered();
        }
    }
}
