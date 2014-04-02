import QtQuick 2.0

Rectangle {

    id: doorsRectangle
    state: "DEFAULT"

    states:[
        State{
            name: "DEFAULT"
            PropertyChanges{
                target:singlePlayerDoor.anchors
                verticalCenterOffset: 0 - doorsRectangle.height * 2
            }
            PropertyChanges{
                target:versusDoor.anchors
                verticalCenterOffset: 0 - doorsRectangle.height * 2
            }
            PropertyChanges{
                target:networkDoor.anchors
                verticalCenterOffset: 0 - doorsRectangle.height * 2
            }
            PropertyChanges{
                target:defaultDoor.anchors
                verticalCenterOffset: 0
            }
        },
        State{
            name: "SINGLE_PLAYER"
        },
        State{
            name: "VERSUS"
        },
        State{
            name: "NETWORK"
        }
    ]

NumberAnimation {id: defaultDoorUp; target: defaultDoor.anchors; properties: "verticalCenterOffset"; from: 0; to: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: singlePlayerDoorUp; target: singlePlayerDoor.anchors; properties: "verticalCenterOffset"; from: 0; to: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: versusDoorUp; target: versusDoor.anchors; properties: "verticalCenterOffset"; from: 0; to: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: networkDoorUp; target: networkDoor.anchors; properties: "verticalCenterOffset";from: 0; to: 0 - doorsRectangle.height * 2; duration: 1000; }
NumberAnimation {id: defaultDoorDown; target: defaultDoor.anchors; properties: "verticalCenterOffset"; to: 0; from: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: singlePlayerDoorDown; target: singlePlayerDoor.anchors; properties: "verticalCenterOffset"; to: 0; from: 0 - doorsRectangle.height * 2; duration: 1000; }
NumberAnimation {id: versusDoorDown; target: versusDoor.anchors; properties: "verticalCenterOffset"; to: 0; from: 0 - doorsRectangle.height * 2 ; duration: 1000; }
NumberAnimation {id: networkDoorDown; target: networkDoor.anchors; properties: "verticalCenterOffset";to: 0; from: 0 - doorsRectangle.height * 2; duration: 1000; }

transitions:[
    Transition{from: "DEFAULT"; to: "SINGLE_PLAYER"; ScriptAction{script: {
        defaultDoorUp.start();
        singlePlayerDoorDown.start();
    }}},
    Transition{from: "DEFAULT"; to: "VERSUS"; ScriptAction{script: {
        defaultDoorUp.start();
        versusDoorDown.start();
    }}},
    Transition{from: "DEFAULT"; to: "NETWORK"; ScriptAction{script: {
        defaultDoorUp.start();
        networkDoorDown.start();
    }}},
    Transition{from: "SINGLE_PLAYER"; to: "VERSUS"; ScriptAction{script: {
        singlePlayerDoorUp.start();
        versusDoorDown.start();
    }}},
    Transition{from: "SINGLE_PLAYER"; to: "NETWORK"; ScriptAction{script: {
        singlePlayerDoorUp.start();
        networkDoorDown.start();
    }}},
    Transition{from: "VERSUS"; to: "SINGLE_PLAYER"; ScriptAction{script: {
        versusDoorUp.start();
        singlePlayerDoorDown.start();
    }}},
    Transition{from: "VERSUS"; to: "NETWORK"; ScriptAction{script: {
        versusDoorUp.start();
        networkDoorDown.start();
    }}},
    Transition{from: "NETWORK"; to: "VERSUS"; ScriptAction{script: {
        networkDoorUp.start();
        versusDoorDown.start();
    }}},
    Transition{from: "NETWORK"; to: "SINGLE_PLAYER"; ScriptAction{script: {
        networkDoorUp.start();
        singlePlayerDoorDown.start();
    }}}
]





    Rectangle{
        id: defaultDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        color: "#123456"
    }

    Rectangle {
        id: singlePlayerDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0 - doorsRectangle.height * 2
    }

    Rectangle {
        id: versusDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0 - doorsRectangle.height * 2
    }

    Rectangle {
        id: networkDoor
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0 - doorsRectangle.height * 2
    }

    CharacterSelector{
        id: singlePlayerCharacterSelector
        anchors.top: singlePlayerDoor.top
        anchors.horizontalCenter: singlePlayerDoor.horizontalCenter
    }

    GumdropSelector {
        id: singlePlayerGumdropSelector
        anchors.top: singlePlayerCharacterSelector.bottom
        anchors.topMargin: -150
        anchors.horizontalCenter: singlePlayerDoor.horizontalCenter
    }

    DifficultySelector {
        id: difficultySelector
        anchors.top: singlePlayerGumdropSelector.bottom
        anchors.topMargin: -150
        anchors.horizontalCenter: singlePlayerDoor.horizontalCenter
    }

    Rectangle{
        id: singlePlayerStartButton
        width: 100
        height: 50
        color: "green"

        anchors.top: difficultySelector.bottom
        anchors.topMargin: -150
        anchors.horizontalCenter: singlePlayerDoor.horizontalCenter

        MouseArea{
            anchors.fill: parent
            onClicked:{

                var menuSelectedColor;
                if(singlePlayerGumdropSelector.gumdrop_selector_string == "teal")
                {
                    guiPlayerIsWhite = true;
                    menuSelectedColor = 0;
                }
                else if(singlePlayerGumdropSelector.gumdrop_selector_string == "purp")
                {
                    guiPlayerIsWhite = false;
                    menuSelectedColor = 1;
                }
                else{
                    console.log("logic error with gumdrop selector")
                }

                if( !piecesHaveStartedAnimating ){
                    startPieceAnimations();
                    piecesHaveStartedAnimating = true;
                }


                sendPlayerName( "TODO: FIX MEEEE" /*playerNameBox.text*/ );
                startMenu.state = "INVISIBLE"
                isNetworkGame = false;
                clearBoard();

                if( difficultySelector.difficulty_selector_string == "easy" ){
                    readyToStartOnePersonPlay(1, menuSelectedColor);
                }
                else if( difficultySelector.difficulty_selector_string == "med" ) {
                    readyToStartOnePersonPlay(2, menuSelectedColor);
                }
                else if( difficultySelector.difficulty_selector_string == "hard" ) {
                    readyToStartOnePersonPlay(3, menuSelectedColor);
                }
                else{
                    console.log("logic error with difficulty selector")
                }

            }
        }
    }
}
