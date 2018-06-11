import QtQuick 2.0
import Ubuntu.Components 1.3

import AsemanTools 1.0
import TelegramQML 1.0

Item {
    width: isSticker ? units.gu(20) : height
    height: units.gu(17)
    visible: uploading

    property Telegram telegram
    property Message message: telegram.nullMessage

    property bool uploading: message.upload.fileId != 0
    property bool isSticker: telegram.documentIsSticker(message.media.document)

    Icon {
        id: upload_img
        visible: uploading
        anchors.fill: parent
        smooth: true
        source: {
            if(!uploading)
                return ""

            var isImage = Cutegram.fileIsImage(message.upload.location)
            if(isImage)
                return Devices.localFilesPrePath + message.upload.location
            else
                return "image://theme/stock_document" 
        }
        color: {
            if(!uploading)
               return Qt.rgba(0.0, 0.0, 0.0, 0.0)

            var isImage = Cutegram.fileIsImage(message.upload.location)
            if(isImage)
               return Qt.rgba(0.0, 0.0, 0.0, 0.0)
            else
               return Theme.name == "Ubuntu.Components.Themes.SuruDark" ? UbuntuColors.porcelain : Colors.graphite
         }

        property size imageSize: uploading? Cutegram.imageSize(message.upload.location) : Qt.size(0,0)
    }


    Rectangle {
        anchors {
            leftMargin: units.dp(-4)
            rightMargin: units.dp(-5)
            topMargin: units.dp(-1)
            bottomMargin: units.dp(-1)
            fill: filesize_lbl
        }
        color: Qt.rgba(0, 0, 0, 0.3)
        radius: units.dp(2)
    }

    Label {
        id: filesize_lbl
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: units.gu(0.25)
        font.weight: Font.DemiBold
        fontSize: "small"
        color: "white"
        text: uploadedSize + "/" + totalSize

        property string totalSize: Math.floor(message.upload.totalSize/(1024*10.24))/100 + "MB"
        property string uploadedSize: Math.floor(message.upload.uploaded/(1024*10.24))/100 + "MB"
    }


    Rectangle {
        anchors {
            leftMargin: units.dp(-4)
            rightMargin: units.dp(-5)
            topMargin: units.dp(-1)
            bottomMargin: units.dp(-1)
            fill: file_txt
        }
        color: Qt.rgba(0, 0, 0, 0.3)
        radius: units.dp(2)
    }

    Label {
        id: file_txt
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: pbar.top
        anchors.margins: units.gu(0.25)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        elide: Text.ElideRight
        maximumLineCount: 1
        font.weight: Font.DemiBold
        fontSize: "small"
        color: "white"
        text: Tools.fileName(message.upload.location)
    }

    ProgressBar {
        id: pbar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.gu(0.5)
        height: units.dp(3)
        radius: 0
        percent: 100*message.upload.uploaded/message.upload.totalSize
    }
}
