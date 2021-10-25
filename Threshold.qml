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
        x: 174
        y: 580
        width: 240
        height: 200
        visible: false
        color: "#ffffff"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        Layout.preferredHeight: 200
        Layout.preferredWidth: 200

        GridLayout {
            id: grid_thresh_conf
            x: 0
            y: 0
            visible: true
            rows: 3
            columns: 2

            Text {
                id: lbl_threshval
                text: qsTr("Thresh")
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                Layout.preferredHeight: 41
                Layout.preferredWidth: 72
                font.pointSize: 8
            }

            SpinBox {
                id: sb_thresh
                to: 255
                Layout.preferredHeight: 40
                Layout.preferredWidth: 140
                stepSize: 2
                value: 100
                editable: true

                onValueChanged: thresholdScaner.threshold(sb_thresh.value,
                                                          sb_maxValue.value,
                                                          cb_threshType.currentIndex);
            }

            Text {
                id: lbl_maxval
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
                to: 255
                Layout.preferredHeight: 40
                Layout.preferredWidth: 140
                value: 100

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
        y: 601
        text: qsTr("Open file...")
        onClicked: fileDialog.visible = true;
    }

    Button {
        id: btn_threshold
        x: 40
        y: 666
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
            rct_adapt_tresh.visible = true
        }
    }

    Button {
        id: btn_threshold_alt
        x: 40
        y: 727
        text: qsTr("Threshold A")
        onClicked: thresholdScaner.threshold_alt(sb_thresh.value,
                                                 sb_maxValue.value,
                                                 cb_threshType.currentIndex);
    }

    Rectangle {
        id: rct_adapt_tresh
        y: 580
        width: 241
        height: 200
        color: "#ffffff"
        anchors.left: threshConfig.right
        anchors.leftMargin: 20
        visible: false

        GridLayout {
            id: grid_thresh_adapt
            x: 0
            y: 0
            visible: true
            Text {
                id: lbl_threshval1
                text: qsTr("Block Size")
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 8
                Layout.preferredHeight: 41
                Layout.preferredWidth: 72
            }

            SpinBox {
                id: sb_blocksize
                editable: true
                value: 15
                stepSize: 2
                Layout.preferredHeight: 40
                onValueChanged: thresholdScaner.threshold_adapt(
                                    sb_maxValue.value,
                                    cb_threshadapt_mtd.currentIndex,
                                    cb_threshType.currentIndex,
                                    sb_blocksize.value,
                                    sb_offset.value );
                Layout.preferredWidth: 140
                to: 255
            }

            Text {
                id: lbl_threshType1
                text: qsTr("Method")
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 8
                Layout.preferredHeight: 41
                Layout.preferredWidth: 72
            }

            ComboBox {
                id: cb_threshadapt_mtd
                model: ListModel {
                    ListElement {
                        key: "MEAN_C"
                        value: 0
                    }

                    ListElement {
                        key: "GAUSSIAN_C"
                        value: 1
                    }
                }
                flat: false
                editable: false
                textRole: "key"
                currentIndex: 0
                onCurrentIndexChanged: thresholdScaner.threshold_adapt(
                                           sb_maxValue.value,
                                           cb_threshadapt_mtd.currentIndex,
                                           cb_threshType.currentIndex,
                                           sb_blocksize.value,
                                           sb_offset.value );
                Layout.preferredHeight: 40
                Layout.preferredWidth: 140
            }

            Text {
                id: lbl_threshval2
                text: qsTr("Offset")
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 8
                Layout.preferredHeight: 41
                Layout.preferredWidth: 72
            }

            SpinBox {
                id: sb_offset
                editable: true
                value: 10
                stepSize: 2
                Layout.preferredHeight: 40
                onValueChanged: thresholdScaner.threshold_adapt(
                                    sb_maxValue.value,
                                    cb_threshadapt_mtd.currentIndex,
                                    cb_threshType.currentIndex,
                                    sb_blocksize.value,
                                    sb_offset.value );
                Layout.preferredWidth: 140
                to: 255
            }
            rows: 3
            columns: 2
        }
    }

    Button {
        id: btn_threshold_adapt
        x: 539
        y: 727
        text: qsTr("Adapt")
        onClicked: thresholdScaner.threshold_adapt(
                       sb_maxValue.value,
                       cb_threshadapt_mtd.currentIndex,
                       cb_threshType.currentIndex,
                       sb_blocksize.value,
                       sb_offset.value );
    }
}
