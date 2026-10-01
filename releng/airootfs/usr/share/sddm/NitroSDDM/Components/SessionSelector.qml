import QtQuick
import QtQuick.Layouts
import "../Utils/cleanName.js" as Utils

Rectangle {
    id: sessionSelector

    property var sessionsModel: null
    property int currentIndex: 0
    property bool loginVisible: true
    property color accentColor: "#AED68A"
    property color surfaceColor: "#303030"
    property color surfaceVariantColor: "#404040"
    property string regularFont: ""
    signal selectionRequested()

    width: 260
    height: 40
    radius: 20
    border.width: 1
    visible: sessionSelector.loginVisible && sessionsModel && sessionsModel.count > 1
    color: sessionClickArea.pressed ? sessionSelector.surfaceVariantColor : sessionSelector.surfaceColor
    border.color: sessionClickArea.pressed ? sessionSelector.accentColor : sessionSelector.surfaceVariantColor

    scale: sessionClickArea.pressed ? 0.95 : 1.0
    Behavior on scale { NumberAnimation { duration: 100 } }

    RowLayout {
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: "󰟀"
            color: sessionSelector.accentColor
            font.pixelSize: 16
        }

        Text {
            text: {
                if (sessionSelector.sessionsModel && sessionSelector.sessionsModel.count > 0) {
                    var modelIndex = sessionSelector.sessionsModel.index(sessionSelector.currentIndex, 0);
                    var name = sessionSelector.sessionsModel.data(modelIndex, Qt.UserRole + 4);
                    var fallback = sessionSelector.sessionsModel.data(modelIndex, Qt.UserRole + 2);
                    var display = sessionSelector.sessionsModel.data(modelIndex, Qt.DisplayRole);
                    var value = name ? name.toString() : (fallback ? fallback.toString() : (display ? display.toString() : "Session " + (sessionSelector.currentIndex + 1)));
                    return Utils.cleanName(value) + (sessionSelector.sessionsModel.count > 1 ? " ▾" : "");
                }
                return "Hyprland";
            }
            color: "white"
            font.pixelSize: 13
            font.weight: Font.Medium
            font.family: sessionSelector.regularFont
        }
    }

    MouseArea {
        id: sessionClickArea
        anchors.fill: parent
        onClicked: sessionSelector.selectionRequested()
    }

}
