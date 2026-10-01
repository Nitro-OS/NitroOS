import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils/cleanName.js" as Utils

Popup {
    id: selectionPopup

    property var selectionModel: null
    property int currentIndex: 0
    property bool sessionMode: false
    property color baseColor: "#202020"
    property color surfaceColor: "#303030"
    property color surfaceVariantColor: "#404040"
    property color accentColor: "#AED68A"
    property string regularFont: ""
    property string boldFont: ""
    signal indexSelected(int index)

    width: 260
    height: selectionModel ? Math.min(sessionMode ? 250 : 300, selectionModel.count * 50 + 20) : 100
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    onOpened: selectionList.forceActiveFocus()

    background: Rectangle {
        color: selectionPopup.baseColor
        radius: 24
        opacity: 0.95
        border.color: selectionPopup.surfaceVariantColor
        border.width: 1
    }

    enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 } }
    exit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200 } }

    ListView {
        id: selectionList
        anchors.fill: parent
        anchors.margins: 10
        model: selectionPopup.selectionModel
        spacing: 5
        clip: true
        focus: true
        currentIndex: selectionPopup.currentIndex
        highlightFollowsCurrentItem: true

        delegate: ItemDelegate {
            width: parent.width
            height: 40
            property bool isCurrent: index === selectionList.currentIndex

            background: Rectangle {
                color: isCurrent ? selectionPopup.surfaceVariantColor : (hovered ? selectionPopup.surfaceColor : "transparent")
                radius: 12

                Rectangle {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 8
                    width: 4
                    height: isCurrent ? 16 : 0
                    color: selectionPopup.accentColor
                    radius: 2
                    Behavior on height { NumberAnimation { duration: 150 } }
                }
            }

            contentItem: RowLayout {
                anchors.fill: parent
                spacing: 0

                Item { Layout.preferredWidth: 20 }

                Rectangle {
                    visible: !selectionPopup.sessionMode
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    Layout.alignment: Qt.AlignVCenter
                    color: isCurrent ? selectionPopup.accentColor : selectionPopup.surfaceVariantColor
                    radius: 14

                    Text {
                        anchors.centerIn: parent
                        text: {
                            var value = selectionPopup.userNameForIndex(index);
                            return value.charAt(0).toUpperCase();
                        }
                        color: isCurrent ? selectionPopup.baseColor : "white"
                        font.pixelSize: 12
                        font.family: selectionPopup.boldFont
                        font.weight: Font.Bold
                    }
                }

                Text {
                    visible: selectionPopup.sessionMode
                    Layout.preferredWidth: 40
                    text: "󰟀"
                    color: isCurrent ? selectionPopup.accentColor : "gray"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Item {
                    visible: !selectionPopup.sessionMode
                    Layout.preferredWidth: 12
                }

                Text {
                    Layout.fillWidth: true
                    text: {
                        var modelIndex = selectionPopup.selectionModel.index(index, 0);
                        if (selectionPopup.sessionMode) {
                            var name = selectionPopup.selectionModel.data(modelIndex, Qt.UserRole + 4);
                            var fallback = selectionPopup.selectionModel.data(modelIndex, Qt.UserRole + 2);
                            return Utils.cleanName(name ? name : fallback);
                        }

                        return Utils.cleanName(selectionPopup.userNameForIndex(index));
                    }
                    color: isCurrent ? "white" : (hovered ? "#DDDDDD" : "#AAAAAA")
                    font.pixelSize: selectionPopup.sessionMode ? 14 : 15
                    font.family: selectionPopup.regularFont
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    rightPadding: 60
                    elide: Text.ElideRight
                }
            }

            onClicked: selectionPopup.selectIndex(index)
        }

        Keys.onDownPressed: incrementCurrentIndex()
        Keys.onUpPressed: decrementCurrentIndex()
        Keys.onReturnPressed: selectionPopup.selectIndex(currentIndex)
        Keys.onEnterPressed: selectionPopup.selectIndex(currentIndex)
    }

    function userNameForIndex(index) {
        var modelIndex = selectionPopup.selectionModel.index(index, 0);
        var realName = selectionPopup.selectionModel.data(modelIndex, Qt.UserRole + 2);
        var name = selectionPopup.selectionModel.data(modelIndex, Qt.UserRole + 1);
        var edit = selectionPopup.selectionModel.data(modelIndex, Qt.EditRole);
        var display = selectionPopup.selectionModel.data(modelIndex, Qt.DisplayRole);
        return realName ? realName.toString() : (name ? name.toString() : (edit ? edit.toString() : (display ? display.toString() : "U")));
    }

    function selectIndex(index) {
        selectionPopup.indexSelected(index);
        selectionPopup.close();
    }
}
