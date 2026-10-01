import QtQuick

Item {
    id: lockScreen

    property string backgroundSource: ""
    property color accentColor: "white"
    property color textColor: "white"
    property string fontFamily: ""
    property bool contentReady: true
    signal unlockRequested()

    anchors.fill: parent
    visible: false
    opacity: visible ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 400 } }

    Clock {
        id: mainClock
        anchors.centerIn: parent
        backgroundSource: lockScreen.backgroundSource
        baseAccent: lockScreen.accentColor
        fontFamily: lockScreen.fontFamily
        reveal: lockScreen.visible && lockScreen.contentReady
        opacity: lockScreen.contentReady ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    Text {
        text: "Press any key to unlock"
        color: lockScreen.textColor
        font.pixelSize: 16
        anchors {
            top: mainClock.bottom
            horizontalCenter: mainClock.horizontalCenter
            topMargin: 8
        }
        opacity: lockScreen.visible && lockScreen.contentReady ? 0.5 : 0
        Behavior on opacity { NumberAnimation { duration: 350 } }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: lockScreen.unlockRequested()
    }
}
