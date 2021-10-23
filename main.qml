import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
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
        filename: ""
        thresh: slider.value
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.pictures
        visible: false
        onAccepted: {
            btn_file_open.visible = false
            detector.filename = fileDialog.fileUrl
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

    RowLayout {
        spacing: 20
        y: wind.height - 50

        Slider {
            id: slider
            width: 226
            live: true
            stepSize: 10
            to: 255
            value: 100
        }
        SpinBox {
            id: spinBox
            stepSize: 0
            editable: false
            to: 255
            value: slider.value
        }

        Label {
            id: label
            x: 230
            text: qsTr("Threshold")
            font.pointSize: 12
        }
    }
}
