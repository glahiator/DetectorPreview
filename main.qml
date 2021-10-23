import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
import DetectorScan 1.0

ApplicationWindow {
    id: wind
    width: 640
    height: 480

    visible: true
    title: qsTr("Hello World")

    DetectorScan {
        id: detector
        anchors.fill: parent
        firstFile: ""
        secondFile: ""
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.pictures
        visible: false
        onAccepted: {
            btn_file_open.visible = false
            detector.firstFile = fileDialog.fileUrl
        }
    }

    FileDialog {
        id: fileDialog2
        title: "Please choose a file"
        folder: shortcuts.pictures
        visible: false
        onAccepted: {
            btn_file_open2.visible = false
            detector.secondFile = fileDialog2.fileUrl
        }
//        Component.onCompleted: visible = true
    }



    Button{
        id: btn_file_open
        anchors.centerIn: parent
        width: 100
        height: 50
        text: "Open 1 file"
        anchors.verticalCenterOffset: 158
        anchors.horizontalCenterOffset: -157
        onClicked: fileDialog.visible = true;
    }

    Button{
        id: btn_file_open2
        anchors.centerIn: parent
        width: 100
        height: 50
        text: "Open 2 file"
        anchors.verticalCenterOffset: 158
        anchors.horizontalCenterOffset: 51
        onClicked: fileDialog2.visible = true;
    }
    Button{
        id: btn_LK
        anchors.centerIn: parent
        width: 100
        height: 50
        text: "LK PYRAMID"
        anchors.verticalCenterOffset: 158
        anchors.horizontalCenterOffset: 248
        onClicked: detector.pyramidLK();
    }
}
