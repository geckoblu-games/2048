import QtQuick 2.2

Rectangle {
    id: tileContainer
    width: cCell
    height: cCell
    radius: 5
    color: "white"
    property string tileText: ""
    property int tileFontSize: 50
    property color tileColor: "black"
    property bool runNewTileAnim: false
    property bool destroyFlag: false

    property string newTileText: ""
    property int newTileFontSize: 50
    property color newTileColor: "black"
    property color newColor: "black"

    Text {
        id: tileLabel
        text: tileText
        color: tileColor
        font.pixelSize: tileFontSize
        font.bold: true
        anchors.centerIn: parent
    }

    ParallelAnimation {
        running: runNewTileAnim
        NumberAnimation {
            target: tileContainer
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: newTileAnimTime
        }

        ScaleAnimator {
            target: tileContainer
            from: 0
            to: 1
            duration: newTileAnimTime
            easing.type: Easing.OutQuad
        }

        // onFinished is invalid ?
        //onRunningChanged: {
        //    if (!running) {
        //        console.log("animation end");
        //        mainWindow.sensitive = true;
        //    }
        //}
    }

    Behavior on newTileText {
        SequentialAnimation {
            PauseAnimation { duration: moveAnimTime }
            ScriptAction {
                script: {
                    tileText = newTileText;
                    tileFontSize =newTileFontSize;
                    tileColor = newTileColor;
                    color = newColor;
                }
            }
            NumberAnimation {
                target: tileContainer
                property: "scale"
                from: 0.3
                to: 1.0
                duration: newTileAnimTime - moveAnimTime
                easing.type: Easing.OutQuad
            }
        }
    }

    Behavior on y {
        NumberAnimation {
            duration: moveAnimTime
            onRunningChanged: {
                if ((!running) && destroyFlag) {
                    tileContainer.destroy();
                }
            }
        }
    }

    Behavior on x {
        id: animationX
        NumberAnimation {
            duration: moveAnimTime
            onRunningChanged: {
                if ((!running) && destroyFlag) {
                    tileContainer.destroy();
                }
            }
        }
    }
}
