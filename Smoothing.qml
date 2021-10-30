import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12


import opencv.Smoothing 1.0

Window {
    id: name
    width: 800
    height: 800
    visible: true

    SmoothingScan {
        id: smooth_scan
        filename: ""
        x: 100
        y: 100
        width: 300
        height: 300
    }

    Button {
        id: btn_openFile
        x: 10
        y: 600
        text: qsTr("Open file...")
        onClicked: fileDialog.visible = true;
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.pictures
        visible: false
        onAccepted: {
            smooth_scan.filename = fileDialog.fileUrl
//            src_img.source = fileDialog.fileUrl
            //            threshConfig.visible = true
            //            rct_adapt_tresh.visible = true
        }
    }
    Column {
        StackLayout {
            id: stackLayout
            x: 10
            y: 10
            width: 200
            height: 200

            Page {
                title: "Page1"
                background:  Rectangle {
                    width: stackLayout.width
                    height: stackLayout.height
                    color: "red"
                }
                // ...
            }
            Page {
                title: "Page2"
                background:  Rectangle {
                    width: stackLayout.width
                    height: stackLayout.height
                    color: "green"
                }
                // ...
            }
            Page {
                title: "Page3"
                background:  Rectangle {
                    width: stackLayout.width
                    height: stackLayout.height
                    color: "blue"
                }
                // ...
            }
        }

        PageIndicator {
            currentIndex: stackLayout.currentIndex
            count: stackLayout.count
            interactive: true
        }
    }

}


