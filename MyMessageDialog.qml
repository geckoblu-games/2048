import QtQuick 6.0

Rectangle {
    id: root

    visible: false

    width: mainWindow.width
    height: mainWindow.height

    color: Qt.rgba(0, 0, 0, 0.3)

    property alias messageText: txt1.text
    property alias btn1Text: btn1.text
    property alias btn2Text: btn2.text

    signal btn1Clicked()
    signal btn2Clicked()

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        color: "#EDE0C8"
        width: mainScene.width / 5 * 4
        height: txt1.height + btn1.height + 40

        radius: 5
        anchors.centerIn: parent

        Text {
            id: txt1
            font.pixelSize: 51
            font.bold: true
            color: myColors.fgdark
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing: 20

            MyButton {
                id: btn1

                onClicked: {
                    close();
                    btn1Clicked();
                }
            }

            MyButton {
                id: btn2

                onClicked: {
                    close();
                    btn2Clicked();
                }

            }

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    function close() {
        visible = false;
        root.z = -1;
        mainScene.forceActiveFocus();
    }

    function open() {
        visible = true;
        root.z = 100;
        forceActiveFocus();
    }


}
