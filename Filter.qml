import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12
import Qt.labs.qmlmodels 1.0

import opencv.Filter 1.0
Window {
    id: wnd_filter
    width: 1200
    height: 800
    visible: true

    FilterScan {
        id: filter_scan
        filename: ""
        x: 100
        y: 100
        width: 300
        height: 300
    }

    Rectangle {
        id: rectangle
        x: 949
        y: 259
        width: 216
        height: 392


        SwipeView {
            id: view
            visible: true

            currentIndex: 0
            anchors.fill: parent
            anchors.topMargin: toolbar.height

            clip: true
            hoverEnabled: false
            enabled: true

            Item {
                id: firstPage
                Rectangle{
                    anchors.fill: parent
                    color: "red"


                    ComboBox {
                        id: cb_ksize_gb
                        x: 46
                        y: 21
                        flat: false
                        textRole: "key"
                        currentIndex: 0
                        editable: true
                        model: ListModel {
                            ListElement {
                                key: "3 x 3"
                            }
                            ListElement {
                                key: "5 x 5"
                            }
                            ListElement {
                                key: "7 x 7"
                            }
                            ListElement {
                                key: "9 x 9"
                            }
                        }
                        onAccepted: {
                            if (find(editText) === -1)
                                model.append({key: editText})
                        }
                    }

                    Button {
                        id: btn_calc_matrix
                        x: 71
                        y: 202
                        text: qsTr("Calc matrix")
                        onClicked: {
//                            console.log( matrix_row1.model.get(0).value,
//                                        matrix_row1.model.get(1).value,
//                                        matrix_row1.model.get(2).value) ;
//                            console.log( matrix_row2.model.get(0).value,
//                                        matrix_row2.model.get(1).value,
//                                        matrix_row2.model.get(2).value) ;
//                            console.log( matrix_row3.model.get(0).value,
//                                        matrix_row3.model.get(1).value,
//                                        matrix_row3.model.get(2).value) ;

                            var m = Qt.matrix4x4();
                            m.m11 = Number.fromLocaleString(locale,  matrix_row1.model.get(0).value );
                            m.m12 = Number.fromLocaleString(locale,  matrix_row1.model.get(1).value );
                            m.m13 = Number.fromLocaleString(locale,  matrix_row1.model.get(2).value );

                            m.m21 = Number.fromLocaleString(locale,  matrix_row2.model.get(0).value );
                            m.m22 = Number.fromLocaleString(locale,  matrix_row2.model.get(1).value );
                            m.m23 = Number.fromLocaleString(locale,  matrix_row2.model.get(2).value );

                            m.m31 = Number.fromLocaleString(locale,  matrix_row3.model.get(0).value );
                            m.m32 = Number.fromLocaleString(locale,  matrix_row3.model.get(1).value );
                            m.m33 = Number.fromLocaleString(locale,  matrix_row3.model.get(2).value );

                            filter_scan.filter2DImage( m );

                        }
                    }

                    Rectangle {
                        id: rectangle2
                        x: 53
                        y: 80
                        width: 130
                        height: 90
                        color: "#ffffff"

                        ListView {
                            id: matrix_row1
                            x: 0
                            y: 0
                            width: 130
                            height: 20
                            anchors.rightMargin: 0

                            orientation: ListView.Horizontal

                            model:     ListModel {
                                ListElement {
                                    value: "0.0"
                                }
                                ListElement {
                                    value: "0.0"
                                }
                                ListElement {
                                    value: "0.0"
                                }
                            }
                            spacing: 2
                            delegate: Rectangle {
                                color:  "#e0e0e0"
                                width: 40; height: 20

                                TextInput {
                                    anchors.fill: parent
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: value
                                    font.pixelSize:12
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    validator: DoubleValidator {
                                        bottom: -100.0
                                        top:  100.0
                                    }
                                    onTextChanged: {
                                        matrix_row1.model.setProperty(index, "value", text );
                                    }
                                }

                            }
                            highlight: Rectangle { color: "lightsteelblue"; }
                            focus: true
                        }

                        ListView {
                            id: matrix_row2
                            x: matrix_row1.x
                            y: matrix_row1.y + 22
                            width: 130
                            height: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            orientation: ListView.Horizontal
                            model:     ListModel {
                                ListElement {
                                    value: "0.0"
                                }
                                ListElement {
                                    value: "0.0"
                                }
                                ListElement {
                                    value: "0.0"
                                }
                            }
                            spacing: 2
                            delegate: Rectangle {
                                color:  "#e0e0e0"
                                width: 40; height: 20

                                TextInput {
                                    anchors.fill: parent
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: value
                                    font.pixelSize:12
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    validator: DoubleValidator {
                                        bottom: -100.0
                                        top:  100.0
                                    }
                                    onTextChanged: {
                                        matrix_row2.model.setProperty(index, "value", text );
                                    }
                                }

                            }
                            highlight: Rectangle { color: "lightsteelblue"; }
                            focus: true
                        }

                        ListView {
                            id: matrix_row3
                            x: matrix_row1.x
                            y: matrix_row1.y + 44
                            width: 130
                            height: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            orientation: ListView.Horizontal
                            model:     ListModel {
                                ListElement {
                                    value: "0.0"
                                }
                                ListElement {
                                    value: "0.0"
                                }
                                ListElement {
                                    value: "0.0"
                                }
                            }
                            spacing: 2
                            delegate: Rectangle {
                                color:  "#e0e0e0"
                                width: 40; height: 20

                                TextInput {
                                    anchors.fill: parent
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: value
                                    font.pixelSize:12
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    validator: DoubleValidator {
                                        bottom: -100.0
                                        top:  100.0
                                    }
                                    onTextChanged: {
                                        matrix_row3.model.setProperty(index, "value", text );
                                    }
                                }

                            }
                            highlight: Rectangle { color: "lightsteelblue"; }
                            focus: true
                        }
                    }


                }
            }
            Item {
                id: secondPage
                Rectangle{
                    anchors.fill: parent
                    color: "green"
                }
            }
            Item {
                id: thirdPage
                Rectangle{
                    anchors.fill: parent
                    color: "blue"
                }
            }
        }

        ToolBar {
            id: toolbar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            RowLayout {
                anchors.fill: parent
                ToolButton {
                    text: qsTr("‹")
                    onClicked: view.currentIndex =view.currentIndex - 1
                }
                Label {
                    text: "Title"
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }
                ToolButton {
                    text: qsTr(">")
                    onClicked: view.currentIndex =view.currentIndex + 1
                }
            }
        }



        PageIndicator {
            id: indicator

            count: view.count
            currentIndex: view.currentIndex

            anchors.bottom: view.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ColumnLayout {
        }
    }

    RowLayout {
        x: 33
        y: 31
        width: 311
        height: 40

        Button {
            id: btn_open_image
            text: qsTr("Open image")
            onClicked: fileDialog.visible = true;

        }

        Button {
            id: btn_reset_image
            text: qsTr("Reset image")
            onClicked:  filter_scan.resetImage();
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.pictures
        visible: false
        onAccepted: {
            filter_scan.filename = fileDialog.fileUrl
            rct_boxfilter.visible = true
            //            src_img.source = fileDialog.fileUrl
            //            threshConfig.visible = true
            //            rct_adapt_tresh.visible = true
        }
    }


}


/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}D{i:5}D{i:11}D{i:13}D{i:22}D{i:31}D{i:12}D{i:4}D{i:3}D{i:41}
D{i:40}D{i:43}D{i:42}D{i:2}D{i:46}D{i:47}D{i:48}D{i:45}D{i:44}D{i:49}D{i:50}D{i:1}
D{i:52}D{i:53}D{i:51}
}
##^##*/
