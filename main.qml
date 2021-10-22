import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.2
import DetectorScan 1.0

Window {
    id: wind
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    DetectorScan {
        id: detector
        anchors.fill: parent
        filepath: "ss"
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.pictures
        visible: false
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)
            btn_file_open.visible = false
            detector.filepath = fileDialog.fileUrl
        }
        onRejected: {
            console.log("Canceled")
        }
        Component.onCompleted: visible = true
    }

    Button{
        id: btn_file_open
        anchors.centerIn: parent
        width: 100
        height: 50
        text: "Open"
        onClicked: fileDialog.visible = true;
    }

}
