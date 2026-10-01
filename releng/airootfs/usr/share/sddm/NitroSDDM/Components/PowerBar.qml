import QtQuick

Rectangle {
    id: powerBarRoot
    height: 44
    width: powerContent.childrenRect.width + 32
    visible: true
    radius: height / 2
    color: powerBarRoot.surfaceColor
    border.width: 1
    border.color: powerBarRoot.accentColor

    property color textColor: "white"
    property color surfaceColor: "#121a12"
    property color accentColor: "#7fbf7f"

    FontLoader { id: iconFont; source: "../Assets/fonts/MaterialDesignIcons.ttf" }

    Row {
        id: powerContent
        anchors.centerIn: parent
        spacing: 20

        Row {
        id: batteryRow
        spacing: 5
        visible: typeof battery !== "undefined" && typeof battery.percent !== "undefined"
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: batteryText
            text: (typeof battery !== "undefined" ? battery.percent : "0") + "%"
            color: textColor
            font.pixelSize: 14
            font.weight: Font.Medium
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            id: batteryIcon
            text: (typeof battery !== "undefined" && battery.charging) ? "󱐋" : "󰁹"
            color: textColor
            font.pixelSize: 18
            font.family: iconFont.name
            anchors.verticalCenter: parent.verticalCenter
        }

        Timer {
            interval: 5000
            running: typeof battery !== "undefined" && battery.present
            repeat: true
            onTriggered: {
                batteryText.text = battery.percent + "%"
                batteryIcon.text = battery.charging ? "󱐋" : "󰁹"
            }
        }
        }

        Text {
        text: (typeof keyboard !== "undefined" && keyboard.layouts[keyboard.currentLayout]) ? keyboard.layouts[keyboard.currentLayout].shortName : "US"
        color: textColor
        font.pixelSize: 14
        font.capitalization: Font.AllUppercase
        visible: typeof keyboard !== "undefined" && keyboard.layouts.length > 1
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: {
                keyboard.currentLayout = (keyboard.currentLayout + 1) % keyboard.layouts.length
            }
        }
        }

        Text {
        text: "󰤄"
        color: textColor
        font.pixelSize: 20
        font.family: iconFont.name
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            onClicked: sddm.suspend()
        }
        }

        Text {
        text: "󰑐"
        color: textColor
        font.pixelSize: 20
        font.family: iconFont.name
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            onClicked: sddm.reboot()
        }
        }

        Text {
        text: "󰐥"
        color: textColor
        font.pixelSize: 20
        font.family: iconFont.name
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            onClicked: sddm.powerOff()
            }
        }
    }
}
