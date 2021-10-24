import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0

import opencv.Threshold 1.0

Window {
    id: name
    width: 800
    height: 800
    visible: true

    Rectangle {
        id: src_rct
        width: 300
        height: 300
//        color: "#e45353"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.leftMargin: 40
//        implicitHeight: src_img.height
//        implicitWidth: src_img.width
        Layout.preferredHeight: 200
        Layout.preferredWidth: 200
        Image {
            id: src_img
            source: ""
            anchors.fill: parent
//            onWidthChanged: src_rct.width = width
//            onHeightChanged: src_rct.height = height
        }
    }

//    Rectangle {
//        id: dst_img

        ThresholdScan {
            x: 490
            width: 300
            height: 300
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.rightMargin: 40
            Layout.preferredHeight: 200
            Layout.preferredWidth: 200

            id: thresholdScaner
            filename: ""

        }


    Rectangle {
        id: threshConfig
        x: 532
        y: 609
        width: 240
        height: 200
        visible: false
        color: "#ffffff"
        anchors.right: parent.right
        anchors.rightMargin: 28
        Layout.preferredHeight: 200
        Layout.preferredWidth: 200

        GridLayout {
            id: grid_thresh_conf
            x: 0
            y: 0
            rows: 3
            columns: 2

            Text {
                id: lbl_threshType2
                text: qsTr("Thresh")
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                Layout.preferredHeight: 41
                Layout.preferredWidth: 72
                font.pointSize: 8
            }

            SpinBox {
                id: sb_thresh
                to: 200
                Layout.preferredHeight: 40
                Layout.preferredWidth: 140
                stepSize: 2
                value: 0
                editable: true

                onValueChanged: thresholdScaner.threshold(sb_thresh.value,
                                                          sb_maxValue.value,
                                                          cb_threshType.currentIndex);
            }

            Text {
                id: lbl_threshType1
                text: qsTr("Max Val")
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                Layout.preferredHeight: 41
                Layout.preferredWidth: 72
                font.pointSize: 8
            }

            SpinBox {
                id: sb_maxValue
                editable: true
                to: 200
                Layout.preferredHeight: 40
                Layout.preferredWidth: 140

                onValueChanged: thresholdScaner.threshold(sb_thresh.value,
                                                          sb_maxValue.value,
                                                          cb_threshType.currentIndex);
            }

            Text {
                id: lbl_threshType
                text: qsTr("Type")
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                Layout.preferredHeight: 41
                Layout.preferredWidth: 72
                font.pointSize: 8
            }

            ComboBox {
                id: cb_threshType
                Layout.preferredHeight: 40
                Layout.preferredWidth: 140
                editable: false
                flat: false
                currentIndex: 0
                textRole: "key"
                model: ListModel {
                    ListElement { key: "BINARY"; value: 0 }
                    ListElement { key: "BINARY_INV"; value: 1 }
                    ListElement { key: "TRUNC"; value: 2 }
                    ListElement { key: "TOZERO"; value: 3 }
                    ListElement { key: "TOZERO_INV"; value: 4 }
                }
                onCurrentIndexChanged: thresholdScaner.threshold(sb_thresh.value,
                                                                 sb_maxValue.value,
                                                                 cb_threshType.currentIndex);
            }
        }
    }

    Button {
        id: btn_openFile
        x: 40
        y: 663
        text: qsTr("Open file...")
        onClicked: fileDialog.visible = true;
    }

    Button {
        id: btn_openFile1
        x: 40
        y: 725
        text: qsTr("Threshold")
        onClicked: thresholdScaner.threshold(sb_thresh.value,
                                             sb_maxValue.value,
                                             cb_threshType.currentIndex);
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.pictures
        visible: false
        onAccepted: {
            thresholdScaner.filename = fileDialog.fileUrl
            src_img.source = fileDialog.fileUrl
            threshConfig.visible = true
        }
    }
}
