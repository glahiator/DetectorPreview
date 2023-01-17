import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12
import Qt.labs.qmlmodels 1.0

import opencv.Filter 1.0
import opencv.Drawing 1.0
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
        width: imgWidth
        height: imgHeight
        visible: false
    }
    DrawingScan {
        id: drawing_scan
        filename: ""
        x: 100
        y: 100
        width: imgWidth
        height: imgHeight
        visible: true

        onSrcImageSizeChanged: {
            console.log(imgWidth, imgHeight);
            sb_resize_width.value = imgWidth;
            sb_resize_height.value = imgHeight;
        }
    }

    function sobel() {
        var x_ord = sb_x_order.value;
        var y_ord = sb_y_order.value;
        var ksize = sb_ksize.value;
        var scale = sb_scale.value;
        var delta = sb_delta.value;

        if( is_scharr.checked ) {
            filter_scan.scharrDeriv(x_ord, y_ord, scale, delta);
        }
        if( is_laplac.checked ) {
            filter_scan.laplacianDeriv(ksize, scale, delta);
        }
        else{
            filter_scan.sobelDeriv(x_ord, y_ord, ksize, scale, delta);
        }
    }

    function morphology() {
        var op = cb_morh_op.model.get(cb_morh_op.currentIndex).value;
        var shape = cb_morh_shape.model.get(cb_morh_shape.currentIndex).value;
        var iter = sb_morph_iter.value;
        var ksize = sb_morph_ksize.value;
        filter_scan.morphologyEx(op, iter, shape, ksize);
    }

    function colorMapping() {
        var colorType = cb_color_map.model.get( cb_color_map.currentIndex ).value;
        filter_scan.applyColorMap(colorType);
    }

    function resizeImage() {
        var interType = cb_resize_img.model.get( cb_resize_img.currentIndex ).value;
        var width = sb_resize_width.value;
        var height = sb_resize_height.value;
        if( width != 0 && height != 0 ){
            drawing_scan.resize(width, height, interType);
        }
    }

    Rectangle {
        id: rectangle
        x: 949
        y: 259
        width: 230
        height: 392


        SwipeView {
            id: view
            visible: true

            currentIndex: 4
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

                    ColumnLayout {
                        x: 10
                        y: 20

                        RowLayout {
                            spacing: 4
                            visible: (is_laplac.checked) ? false : true


                            Text {
                                id: text1
                                text: qsTr("X order")
                                font.pixelSize: 12
                                Layout.preferredHeight: 14
                                Layout.preferredWidth: 69
                            }

                            SpinBox {
                                id: sb_x_order
                                to: 3
                                from: 0
                                value: 1
                                onValueChanged: sobel();
                            }
                        }

                        RowLayout {
                            spacing: 4
                            visible: (is_laplac.checked) ? false : true

                            Text {
                                id: text2
                                text: qsTr("Y order")
                                font.pixelSize: 12
                                Layout.preferredHeight: 14
                                Layout.preferredWidth: 69
                            }

                            SpinBox {
                                id: sb_y_order
                                to: 3
                                from: 0
                                value: 1
                                onValueChanged: sobel();
                            }
                        }

                        RowLayout {
                            spacing: 4
                            visible: (is_scharr.checked) ? false : true

                            Text {
                                id: text3
                                text: qsTr("kernel Size")
                                font.pixelSize: 12
                                Layout.preferredHeight: 14
                                Layout.preferredWidth: 69
                            }

                            SpinBox {
                                id: sb_ksize
                                stepSize: 2
                                to: 7
                                from: 1
                                value: 3
                                onValueChanged: sobel();

                            }
                        }

                        RowLayout {
                            spacing: 4
                            Text {
                                id: text4
                                text: qsTr("scale")
                                font.pixelSize: 12
                                Layout.preferredHeight: 14
                                Layout.preferredWidth: 69
                            }

                            SpinBox {
                                id: sb_scale
                                stepSize: 1
                                to: 200
                                from: 1
                                value: 1
                                onValueChanged: sobel();
                            }
                        }

                        RowLayout {
                            spacing: 4
                            Text {
                                id: text5
                                text: qsTr("detla")
                                font.pixelSize: 12
                                Layout.preferredHeight: 14
                                Layout.preferredWidth: 69
                            }

                            SpinBox {
                                id: sb_delta
                                to: 300
                                stepSize: 20
                                onValueChanged: sobel();
                            }
                        }

                        Button {
                            id: btn_sobel
                            text: "Sobel"

                            onClicked: {
                                sobel();
                            }
                        }
                        RowLayout {
                            spacing: 2
                            CheckBox {
                                id: is_scharr
                                text: "SCHARR"
                                checked: false
                                onClicked: sobel();
                            }
                            CheckBox {
                                id: is_laplac
                                text: "LAPLAS"
                                checked: false
                                onClicked: sobel();
                            }
                        }
                    }


                }
            }
            Item {
                id: thirdPage
                Rectangle{
                    anchors.fill: parent
                    color: "#b6b6f8"


                    ColumnLayout {
                        x: 8
                        y: 22

                        RowLayout {

                            Text {
                                id: text_iter1
                                text: qsTr("Operation")
                                font.pixelSize: 12
                                Layout.preferredWidth: 69
                                Layout.preferredHeight: 14
                            }

                            ComboBox {
                                id: cb_morh_op
                                flat: false
                                textRole: "key"
                                currentIndex: 0
                                editable: false
                                model: ListModel {
                                    ListElement {
                                        key: "ERODE"
                                        value: 0
                                    }

                                    ListElement {
                                        key: "DILATE"
                                        value: 1
                                    }

                                    ListElement {
                                        key: "OPEN"
                                        value: 2
                                    }

                                    ListElement {
                                        key: "CLOSE"
                                        value: 3
                                    }

                                    ListElement {
                                        key: "GRADIENT"
                                        value: 4
                                    }
                                    ListElement {
                                        key: "TOPHAT"
                                        value: 5
                                    }

                                    ListElement {
                                        key: "BLACKHAT"
                                        value: 6
                                    }
                                }
                                onCurrentIndexChanged: {
                                    morphology();
                                }
                            }
                        }

                        RowLayout {

                            Text {
                                id: text_iter2
                                text: qsTr("Shape")
                                font.pixelSize: 12
                                Layout.preferredWidth: 69
                                Layout.preferredHeight: 14
                            }

                            ComboBox {
                                id: cb_morh_shape
                                flat: false
                                textRole: "key"
                                currentIndex: 0
                                editable: false
                                model: ListModel {
                                    ListElement {
                                        key: "RECT"
                                        value: 0
                                    }

                                    ListElement {
                                        key: "CROSS"
                                        value: 1
                                    }

                                    ListElement {
                                        key: "ELLIPSE"
                                        value: 2
                                    }
                                }
                                onCurrentIndexChanged: {
                                    morphology();
                                }
                            }
                        }

                        RowLayout {

                            Text {
                                id: text_ksize
                                text: qsTr("Kernel size")
                                font.pixelSize: 12
                                Layout.preferredHeight: 14
                                Layout.preferredWidth: 69
                            }

                            SpinBox {
                                id: sb_morph_ksize
                                to: 19
                                from: 1
                                value: 3
                                stepSize: 2
                                onValueChanged: morphology();
                            }
                        }

                        RowLayout {

                            Text {
                                id: text_iter
                                text: qsTr("Iterations")
                                font.pixelSize: 12
                                Layout.preferredHeight: 14
                                Layout.preferredWidth: 69
                            }

                            SpinBox {
                                id: sb_morph_iter
                                to: 100
                                from: 1
                                value: 1
                                onValueChanged: morphology();
                            }
                        }
                    }
                }
            }
            Item{
                id: fourthPage
                Rectangle{
                    anchors.fill: parent
                    color: "#b6b6f8"

                    ComboBox {
                        id: cb_color_map
                        x: 45
                        y: 57
                        flat: false
                        textRole: "key"
                        currentIndex: 0
                        editable: false
                        model: ListModel {
                            ListElement {
                                key: "AUTUMN"
                                value: 0
                            }
                            ListElement {
                                key: "BONE"
                                value: 1
                            }
                            ListElement {
                                key: "JET"
                                value: 2
                            }
                            ListElement {
                                key: "WINTER"
                                value: 3
                            }
                            ListElement {
                                key: "RAINBOW"
                                value: 4
                            }
                            ListElement {
                                key: "OCEAN"
                                value: 5
                            }
                            ListElement {
                                key: "SUMMER"
                                value: 6
                            }
                            ListElement {
                                key: "SPRING"
                                value: 7
                            }
                            ListElement {
                                key: "COOL"
                                value: 8
                            }
                            ListElement {
                                key: "HSV"
                                value: 9
                            }
                            ListElement {
                                key: "PINK"
                                value: 10
                            }
                            ListElement {
                                key: "HOT"
                                value: 11
                            }
                            ListElement {
                                key: "PARULA"
                                value: 12
                            }
                            ListElement {
                                key: "MAGMA"
                                value: 13
                            }

                            ListElement {
                                key: "INFERNO"
                                value: 14
                            }
                            ListElement {
                                key: "PLASMA"
                                value: 15
                            }
                            ListElement {
                                key: "VIRIDIS"
                                value: 16
                            }
                            ListElement {
                                key: "CIVIDIS"
                                value: 17
                            }
                            ListElement {
                                key: "TWILIGHT"
                                value: 18
                            }
                            ListElement {
                                key: "TWILIGHT_SHIFTED"
                                value: 19
                            }
                            ListElement {
                                key: "TURBO"
                                value: 20
                            }
                            ListElement {
                                key: "DEEPGREEN"
                                value: 21
                            }
                        }
                        onCurrentIndexChanged: {
                            colorMapping();
                        }
                    }

                    Button{
                        x: 10
                        y: 100
                        width: 100
                        height: 50
                        text: "Pyr Down"
                        onClicked: filter_scan.pyrDown();
                    }

                    Button{
                        x: 10
                        y: 160
                        width: 100
                        height: 50
                        text: "Pyr Up"
                        onClicked: filter_scan.pyrUp();
                    }
                }
            }
            Item {
                id: fivePage
                Rectangle{
                    anchors.fill: parent
                    color: "#b6b6f8"

                    ColumnLayout {
                        x: 23
                        y: 51

                        RowLayout {

                            Label {
                                id: label
                                text: qsTr("Width ")
                            }

                            SpinBox {
                                id: sb_resize_width
                                editable: true
                                stepSize: 100
                                to: 1500
                                onValueChanged: resizeImage()
                            }
                        }

                        RowLayout {

                            Label {
                                id: label1
                                text: qsTr("Height")
                            }

                            SpinBox {
                                id: sb_resize_height
                                editable: true
                                stepSize: 100
                                to: 1500
                                onValueChanged: resizeImage();
                            }
                        }

                        RowLayout {

                            Label {
                                id: label2
                                text: qsTr("Interp ")
                            }

                            ComboBox {
                                id: cb_resize_img
                                flat: false
                                textRole: "key"
                                currentIndex: 0
                                editable: false

                                model: ListModel {
                                    ListElement {
                                        key: "NEAREST"
                                        value: 0
                                    }
                                    ListElement {
                                        key: "LINEAR"
                                        value: 1
                                    }
                                    ListElement {
                                        key: "CUBIC"
                                        value: 2
                                    }
                                    ListElement {
                                        key: "AREA"
                                        value: 3
                                    }
                                    ListElement {
                                        key: "LANCZOS4"
                                        value: 4
                                    }
                                    ListElement {
                                        key: "LINEAR_EXACT"
                                        value: 5
                                    }

                                }
                                onCurrentIndexChanged: {
                                    resizeImage();
                                }
                            }
                        }
                    }
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
            onClicked:  {
                drawing_scan.resetImage();
                filter_scan.resetImage();
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.pictures
        visible: false
        onAccepted: {
            filter_scan.filename = fileDialog.fileUrl;
            drawing_scan.filename = fileDialog.fileUrl;
        }
    }



}


/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}D{i:1}D{i:2}D{i:7}D{i:13}D{i:15}D{i:24}D{i:33}D{i:14}D{i:6}
D{i:5}D{i:46}D{i:47}D{i:45}D{i:49}D{i:50}D{i:48}D{i:52}D{i:53}D{i:51}D{i:55}D{i:56}
D{i:54}D{i:58}D{i:59}D{i:57}D{i:60}D{i:62}D{i:63}D{i:61}D{i:44}D{i:43}D{i:42}D{i:68}
D{i:69}D{i:67}D{i:79}D{i:80}D{i:78}D{i:86}D{i:87}D{i:85}D{i:89}D{i:90}D{i:88}D{i:66}
D{i:65}D{i:64}D{i:93}D{i:117}D{i:118}D{i:92}D{i:91}D{i:123}D{i:124}D{i:122}D{i:126}
D{i:127}D{i:125}D{i:129}D{i:130}D{i:128}D{i:121}D{i:120}D{i:119}D{i:4}D{i:140}D{i:141}
D{i:142}D{i:139}D{i:138}D{i:143}D{i:144}D{i:3}D{i:146}D{i:147}D{i:145}D{i:148}
}
##^##*/
