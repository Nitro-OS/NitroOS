import QtQuick

Rectangle {
    id: datePill

    property color accentColor: "white"
    property color surfaceColor: "#303030"
    property string fontFamily: ""
    property bool contentReady: true

    width: dateText.implicitWidth + 28
    height: 40
    color: datePill.surfaceColor
    radius: 20
    border.width: 1
    border.color: datePill.accentColor
    opacity: datePill.contentReady ? 1 : 0

    Behavior on opacity { NumberAnimation { duration: 300 } }

    Text {
        id: dateText
        anchors.centerIn: parent
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d, yyyy")
        color: datePill.accentColor
        font.pixelSize: 15
        font.family: datePill.fontFamily
    }
}
