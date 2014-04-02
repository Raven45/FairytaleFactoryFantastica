import QtQuick 2.0

Item {
    id: witch
     y: 170
     state: "ON"

    Image{
        id: witch_image
        width: 200; height: 124
        source: "TheWitch.png"
        mirror: false
    }

    states: [
        State{
            name: "ON"
            PropertyChanges { target: witch;  y: 170 }
            PropertyChanges { target: witch_image; mirror: false }
            PropertyChanges { target: witch_animation; running: true }
        },
        State{
            name: "OFF"
            PropertyChanges { target: witch_animation; running: false }
        }

    ]

    SequentialAnimation{
        id: witch_animation
        running: true;
        loops: Animation.Infinite

        NumberAnimation {
            target: witch
            properties: "x"
            from: -1000
            to: 2000;
            duration: 4000;
        }

        ScriptAction{
            script: {
                //javascript to flip the witch around
                witch_image.mirror = true;
            }
        }

        NumberAnimation {
            target: witch
            properties: "x"
            from: 2000
            to: -1000
            duration: 4000
        }

        ScriptAction{
            script: {
                //javascript to flip the witch around
                witch_image.mirror = false;
            }
        }
    }
}

