import QtQuick 6.0
import QtQuick.Window 6.0
import QtQuick.Controls 6.0

import Qt.labs.settings 1.1

import "2048.js" as Model

Window {
    id: mainWindow
    visible: false
    width: mainScene.width
    height: 620
    title: qsTr("2048");

    color: myColors.bglight

    Timer {
        id: moveRelease
        interval: 300
    }

    readonly property int cBorder: 10
    readonly property int cCell: 100
    readonly property int moveAnimTime: 150
    readonly property int newTileAnimTime: 300

    property var myColors: {
        "bglight": "#FAF8EF",
        "bggray": Qt.rgba(238/255, 228/255, 218/255, 0.35),
        "bgdark": "#BBADA0",
        "fglight": "#EEE4DA",
        "fgdark": "#776E62",
        "bgbutton": "#8F7A66", // Background color for the "New Game" button
        "fgbutton": "#F9F6F2" // Foreground color for the "New Game" button
    }

    Settings {
        id: settings
        property bool firstRun: true
        property int score: 0
        property int bestScore: 0
        property var cellValues: []
        property bool checkTargetFlag: true

        property int mainWindowX: (Screen.width - width) / 2
        property int mainWindowY: (Screen.height - height) / 2
    }

    Rectangle {
        id: mainScene
        visible: true
        width: gGrid.width + cBorder * 2
        height: subScene.height + cBorder * 2

        color: myColors.bglight

        anchors.centerIn: parent

        focus: true
        Keys.onPressed: {
            Model.moveKey(event.key);
            switch (event.key) {
            case Qt.Key_Left:
            case Qt.Key_Right:
            case Qt.Key_Up:
            case Qt.Key_Down:
                event.accepted = true;
            }
        }

        Item {
            id: subScene
            width: gGrid.width
            height: 600
            anchors.centerIn: parent


            MouseArea {
                anchors.fill: parent
                onClicked: parent.forceActiveFocus()
            }

            Text {
                id: gameName
                font.pixelSize: 51
                font.bold: true
                text: "2048"
                color: myColors.fgdark
                anchors.verticalCenter: bestScoreText.verticalCenter
            }

            Rectangle {
                id: bestScoreText
                width: cCell + cBorder * 2
                height: 50
                radius: 3
                color: myColors.bgdark
                anchors.right: parent.right

                property string text: "0"
                Text {
                    text: qsTr("BEST")
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 4
                    font.pixelSize: 12
                    color: myColors.fglight
                }
                Text {
                    text: parent.text
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 19
                    font.pixelSize: 23
                    font.bold: true
                    color: "white"
                }
            }

            Rectangle {
                id: scoreText
                width: cCell + cBorder * 2 // 90
                height: 50
                radius: 3
                color: myColors.bgdark
                anchors.right: bestScoreText.left
                anchors.rightMargin: 5

                property string text: "0"
                Text {
                    text: qsTr("SCORE")
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 4
                    font.pixelSize: 12
                    color: myColors.fglight
                }
                Text {
                    id: scoreTextText
                    text: parent.text
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 19
                    font.pixelSize: 23
                    font.bold: true
                    color: "white"
                }

                Text {
                    id: addScoreText
                    font.pixelSize: 23
                    font.bold: true
                    color: Qt.rgba(119/255, 110/255, 101/255, 0.9);
                    anchors.horizontalCenter: scoreTextText.horizontalCenter
                    y: scoreTextText.y

                    property bool runAddScore: false
                    property real yfrom: scoreTextText.y
                    property real yto: -(parent.y + parent.height)
                    property int addScoreAnimTime: 600

                    ParallelAnimation {
                        id: addScoreAnim
                        running: false

                        NumberAnimation {
                            target: addScoreText
                            property: "y"
                            from: addScoreText.yfrom
                            to: addScoreText.yto
                            duration: addScoreText.addScoreAnimTime

                        }
                        NumberAnimation {
                            target: addScoreText
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: addScoreText.addScoreAnimTime
                        }
                    }
                }
            }

            Text {
                id: banner
                height: 38
                anchors.verticalCenter: newGameButton.verticalCenter
                text: qsTr("Join the numbers and get to the <b>2048 tile</b>!")
                color: myColors.fgdark
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                id:mouseArea

                enabled: true

                anchors.fill: parent

                property int startX // initial position X
                property int startY // initial position Y
                property bool moving: false

                //The three methods below check swiping direction
                //and call an appropriate method accordingly
                onPressed: {
                    startX = mouse.x //save initial position X
                    startY = mouse.y //save initial position Y
                    moving = false
                }

                onReleased: {
                    moving = false
                }

                onPositionChanged: {
                    var deltax = mouse.x - startX
                    var deltay = mouse.y - startY

                    if (moving === false) {
                        if (Math.abs(deltax) > 40 || Math.abs(deltay) > 40) {
                            moving = true

                            if (deltax > 30 && Math.abs(deltay) < 30 && moveRelease.running === false) {
                                Model.moveKey(Qt.Key_Right);
                            }
                            else if (deltax < -30 && Math.abs(deltay) < 30 && moveRelease.running === false) {
                                Model.moveKey(Qt.Key_Left);
                            }
                            else if (Math.abs(deltax) < 30 && deltay > 30 && moveRelease.running === false) {
                                Model.moveKey(Qt.Key_Down);
                            }
                            else if (Math.abs(deltax) < 30 && deltay < 30 && moveRelease.running === false) {
                                Model.moveKey(Qt.Key_Up);
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: gGrid
                width: cCell * 4 + cBorder * 5
                height: width
                anchors.bottom: parent.bottom
                color: myColors.bgdark
                radius: 5

                Grid {
                    id: tileGrid
                    x: spacing;
                    y: spacing;
                    rows: 4; columns: 4; spacing: cBorder

                    Repeater {
                        id: cells
                        model: 16
                        Rectangle {
                            width: cCell
                            height: width
                            radius: 5
                            color: myColors.bggray
                        }
                    }
                }
            }

            MyButton {
                id: newGameButton

                anchors.right: parent.right
                anchors.bottom: gGrid.top
                anchors.bottomMargin: 38

                text: qsTr("New Game")

                onClicked: Model.newGame()
            }
        }


    }

    MyMessageDialog {
        id: deadMessage
        z: -1

        anchors.centerIn: mainScene

        messageText: qsTr("Game over!")
        btn1Text: qsTr("Try again")
        btn2Text: qsTr("Quit")

        onBtn1Clicked: {
            // Try again
            Model.newGame();
        }

        onBtn2Clicked: {
            // Quit game
            Model.newGame();
            Qt.quit();
        }
    }

    MyMessageDialog {
        id: winMessage
        z: -1

        anchors.centerIn: mainScene

        messageText: qsTr("You win!")
        btn1Text: qsTr("Keep going")
        btn2Text: qsTr("Try again")

        onBtn1Clicked: {
            // Keep going
            Model.checkTargetFlag = false;
        }

        onBtn2Clicked: {
            // Try again
            Model.newGame();
        }
    }

    Loader {
        id: firstLoadDialogLoader
    }

    Component.onCompleted: {

        x = settings.mainWindowX;
        y = settings.mainWindowY;

        Model.bestScore = settings.bestScore;

        if (settings.firstRun) {
            firstLoadDialogLoader.setSource("FirstLoad.qml");
            Model.newGame();
        } else {
            // settings.cellValues = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,10,10]];
            Model.reloadGame(settings.score, settings.cellValues, settings.checkTargetFlag);
        }

        visible = true;
    }

    Component.onDestruction: {
        // console.log("Component destruction");
        settings.score = Model.score;
        settings.bestScore = Model.bestScore;
        settings.cellValues = Model.cellValues;
        settings.checkTargetFlag = Model.checkTargetFlag;
        settings.firstRun = false;

        settings.mainWindowX = x;
        settings.mainWindowY = y;
    }
}
