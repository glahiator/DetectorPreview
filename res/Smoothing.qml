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

    Button {
        id: btn_resetImage
        x: 10
        y: 659
        visible: true
        text: qsTr("Reset Image")

        onClicked: smooth_scan.resetImage();
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.pictures
        visible: false
        onAccepted: {
            smooth_scan.filename = fileDialog.fileUrl
            rct_boxfilter.visible = true
            //            src_img.source = fileDialog.fileUrl
            //            threshConfig.visible = true
            //            rct_adapt_tresh.visible = true
        }
    }

    function boxFilterDraw() {
        var mySize = cb_ksize.currentText.split(",");
        var qtsize = Qt.size( mySize[0], mySize[1] );
        var myPoinit = cb_anchor.currentText.split(",");
        var qtpoint = Qt.point( myPoinit[0], myPoinit[1] );
        var borderType = cb_bordertype.model.get(cb_bordertype.currentIndex).value;
        var isNormalized = chb_norma.checked;
        smooth_scan.boxFilterDraw(qtsize, qtpoint, isNormalized, borderType);
    }

    function medianBlurDraw() {
        var appert_lin = sb_appert_lin_size.value ;
        smooth_scan.medianBlur( appert_lin );
    }

    function gaussianBlurDraw() {
        var mySize = cb_ksize_gb.currentText.split(",");
        var qtsize = Qt.size( mySize[0], mySize[1] );
        var sigmaX = sb_sigmaX.realValue;
        var sigmaY = sb_sigmaY.realValue;
        var borderType = cb_bordertype_gaus.model.get(cb_bordertype_gaus.currentIndex).value;
        smooth_scan.gaussianBlur( qtsize, sigmaX, sigmaY, borderType );
    }

    function bilateralFilter() {
        var sigma_place = sb_sigma_place.realValue;
        var sigma_color = sb_sigma_color.realValue;
        var pixl_nei_size = sb_pixel_neigh.value;
        var borderType = cb_bordertype_gaus.model.get(cb_bordertype_gaus.currentIndex).value;
        smooth_scan.bilateralFilter( pixl_nei_size, sigma_color, sigma_place, borderType );
    }

    ColumnLayout {
        x: 295
        y: 572
        spacing: 5

        Label {
            id: label
            text: qsTr("Apperture linear size")
        }

        SpinBox {
            id: sb_appert_lin_size
            value: 5
            stepSize: 2
            from: 1
            onValueChanged: {
                medianBlurDraw();
            }
        }
    }

    ColumnLayout {
        x: 590
        y: 233

        Text {
            id: lbl_ksize1
            text: qsTr("Kernel size, cv::Size")
            font.pixelSize: 12
            smooth: true
            antialiasing: true
        }

        ComboBox {
            id: cb_ksize_gb
            flat: false
            textRole: "key"
            currentIndex: 0
            editable: true
            model: ListModel {
                ListElement {
                    key: "1,1"
                    value: 1
                }
                ListElement {
                    key: "3,3"
                    value: 1
                }
                ListElement {
                    key: "5,5"
                    value: 3
                }
                ListElement {
                    key: "7,7"
                    value: 1
                }
                ListElement {
                    key: "9,9"
                    value: 3
                }
            }
            onAccepted: {
                if (find(editText) === -1)
                    model.append({key: editText})
            }
            onCurrentTextChanged: {
                gaussianBlurDraw();
            }
        }

        Label {
            id: label1
            text: qsTr("sigma X")
        }

        SpinBox {
            id: sb_sigmaX
            stepSize: 10
            from: -10000
            value: 100
            to: 10000

            editable: true

            property int decimals: 2
            property real realValue: value / 100

            validator: DoubleValidator {
                bottom: Math.min(sb_sigmaX.from, sb_sigmaX.to)
                top:  Math.max(sb_sigmaX.from, sb_sigmaX.to)
            }

            textFromValue: function(value, locale) {
                return Number(value / 100).toLocaleString(locale, 'f', sb_sigmaX.decimals)
            }

            valueFromText: function(text, locale) {
                return Number.fromLocaleString(locale, text) * 100
            }

            onValueChanged: {
                gaussianBlurDraw();
            }
        }

        Label {
            id: label2
            text: qsTr("sigma Y")
        }

        SpinBox {
            id: sb_sigmaY
            from: -10000
            value: 0
            to: 10000
            stepSize: 10
            editable: true

            property int decimals: 2
            property real realValue: value / 100

            validator: DoubleValidator {
                bottom: Math.min(sb_sigmaX.from, sb_sigmaX.to)
                top:  Math.max(sb_sigmaX.from, sb_sigmaX.to)
            }

            textFromValue: function(value, locale) {
                return Number(value / 100).toLocaleString(locale, 'f', sb_sigmaX.decimals)
            }

            valueFromText: function(text, locale) {
                return Number.fromLocaleString(locale, text) * 100
            }

            onValueChanged: {
                gaussianBlurDraw();
            }
        }

        Text {
            id: lbl_bordertype1
            text: qsTr("Border type")
            font.pixelSize: 12
        }

        ComboBox {
            id: cb_bordertype_gaus
            flat: false
            textRole: "key"
            currentIndex: 4
            editable: false
            model: ListModel {
                ListElement {
                    key: "CONSTANT"
                    value: 0
                }

                ListElement {
                    key: "REPLICATE"
                    value: 1
                }

                ListElement {
                    key: "REFLECT"
                    value: 2
                }

                ListElement {
                    key: "REFLECT_101"
                    value: 4
                }

                ListElement {
                    key: "DEFAULT"
                    value: 4
                }
            }
            onCurrentIndexChanged: {
                gaussianBlurDraw();
            }
        }
    }

    ColumnLayout {
        x: 601
        y: 141
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 590
        anchors.topMargin: 13
        spacing: 2

        Text {
            id: lbl_ksize
            text: qsTr("Kernel size, cv::Size")
            font.pixelSize: 12
        }

        ComboBox {
            id: cb_ksize
            editable: true
            flat: false
            currentIndex: 0
            textRole: "key"
            model: ListModel {
                ListElement { key: "2,2"; value: 0 }
                ListElement { key: "3,3"; value: 1 }
                ListElement { key: "4,4"; value: 2 }
                ListElement { key: "5,5"; value: 3 }
            }
            onAccepted: {
                if (find(editText) === -1)
                    model.append({key: editText})
            }
            onCurrentTextChanged: {
                boxFilterDraw();
            }
        }

        CheckBox {
            id: chb_norma
            text: qsTr("Normalize")
            checked: true
            display: AbstractButton.TextBesideIcon
            onCheckStateChanged: {
                boxFilterDraw();
            }

        }

        Text {
            id: lbl_anchor
            text: qsTr("Anchor, cv::Point")
            font.pixelSize: 12
        }

        ComboBox {
            id: cb_anchor
            editable: true
            flat: false
            currentIndex: 0
            textRole: "key"
            model: ListModel {
                ListElement { key: "-1,-1"; value: 0 }
                ListElement { key: "1,1"; value: 1 }
                ListElement { key: "0,0"; value: 6 }
            }
            onAccepted: {
                if (find(editText) === -1)
                    model.append({key: editText})
            }
            onCurrentTextChanged: {
                boxFilterDraw();
            }
        }

        Text {
            id: lbl_bordertype
            text: qsTr("Border type")
            font.pixelSize: 12
        }

        ComboBox {
            id: cb_bordertype
            editable: false
            flat: false
            currentIndex: 4
            textRole: "key"
            model: ListModel {
                ListElement { key: "CONSTANT"; value: 0 }
                ListElement { key: "REPLICATE"; value: 1 }
                ListElement { key: "REFLECT"; value: 2 }
                ListElement { key: "REFLECT_101"; value: 4 }
                //                    ListElement { key: "TRANSPARENT"; value: 5 }
                ListElement { key: "DEFAULT"; value: 4 }
            }
            onCurrentIndexChanged: {
                boxFilterDraw();
            }

        }
    }

    ColumnLayout {
        x: 590
        y: 512

        Label {
            id: label5
            text: qsTr("Pixel neighborhood size")
        }

        SpinBox {
            value: 9
            from: -10
            id: sb_pixel_neigh
            onValueChanged: bilateralFilter();
        }

        Label {
            id: label3
            text: qsTr("sigma color")
        }

        SpinBox {
            id: sb_sigma_color
            validator: DoubleValidator {
                bottom: Math.min(sb_sigma_color.from, sb_sigma_color.to)
                top: Math.max(sb_sigma_color.from, sb_sigma_color.to)
            }
            property int decimals: 2
            property real realValue: value / 100
            textFromValue: function(value, locale) {
                return Number(value / 100).toLocaleString(locale, 'f', sb_sigma_color.decimals)
            }
            stepSize: 10
            value: 2000
            valueFromText: function(text, locale) {
                return Number.fromLocaleString(locale, text) * 100
            }
            editable: true
            to: 100000
            from: -100000

            onValueChanged: {
                bilateralFilter();
            }
        }

        Label {
            id: label4
            text: qsTr("sigma place")
        }

        SpinBox {
            id: sb_sigma_place
            validator: DoubleValidator {
                bottom: Math.min(sb_sigmaX.from, sb_sigmaX.to)
                top: Math.max(sb_sigmaX.from, sb_sigmaX.to)
            }
            property int decimals: 2
            property real realValue: value / 100
            textFromValue: function(value, locale) {
                return Number(value / 100).toLocaleString(locale, 'f', sb_sigmaX.decimals)
            }
            stepSize: 10

            value: 500
            valueFromText: function(text, locale) {
                return Number.fromLocaleString(locale, text) * 100
            }
            editable: true
            to: 100000
            from: -100000

            onValueChanged: {
                bilateralFilter();
            }
        }

        Text {
            id: lbl_bordertype2
            text: qsTr("Border type")
            font.pixelSize: 12
        }

        ComboBox {
            id: cb_bordertype_bilar
            flat: false
            textRole: "key"
            currentIndex: 4
            editable: false
            model: ListModel {
                ListElement {
                    key: "CONSTANT"
                    value: 0
                }

                ListElement {
                    key: "REPLICATE"
                    value: 1
                }

                ListElement {
                    key: "REFLECT"
                    value: 2
                }

                ListElement {
                    key: "REFLECT_101"
                    value: 4
                }

                ListElement {
                    key: "DEFAULT"
                    value: 4
                }
            }
            onCurrentIndexChanged: {
                bilateralFilter();
            }
        }
    }
}




