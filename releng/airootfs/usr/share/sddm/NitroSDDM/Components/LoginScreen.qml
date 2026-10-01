import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils/cleanName.js" as Utils

Item {
    id: loginScreen

    property var usersModel: null
    property int userIndex: 0
    property bool isLoggingIn: false
    property alias loginVisible: loginState.visible
    property color accentColor: "#AED68A"
    property color surfaceColor: "#303030"
    property color surfaceVariantColor: "#404040"
    property string regularFont: ""
    property string boldFont: ""
    property alias passwordText: passwordField.text
    property bool capsLockOn: false
    property bool numLockOn: false
    signal loginRequested()
    signal userSelectionRequested()

    anchors.fill: parent

    function focusPassword() {
        passwordField.forceActiveFocus();
    }

    function syncKeyboardState() {
        if (typeof keyboard === "undefined") {
            return;
        }
        if (typeof keyboard.capsLock !== "undefined") {
            loginScreen.capsLockOn = keyboard.capsLock === true;
        }
        if (typeof keyboard.numLock !== "undefined") {
            loginScreen.numLockOn = keyboard.numLock === true;
        }
    }

    function updateLockState(event) {
        if (event.key === Qt.Key_CapsLock) {
            loginScreen.capsLockOn = !loginScreen.capsLockOn;
        } else if (event.key === Qt.Key_NumLock) {
            loginScreen.numLockOn = !loginScreen.numLockOn;
        } else {
            loginScreen.capsLockOn = (event.modifiers & Qt.CapsLockModifier) !== 0;
        }
    }

    function showError() {
        loginState.isError = true;
        shakeAnimation.start();
        passwordField.text = "";
        focusPassword();
    }

    function clearError() {
        loginState.isError = false;
    }

    function userNameForIndex(index) {
        if (!loginScreen.usersModel || loginScreen.usersModel.count <= 0) {
            return sddm.lastUser ? sddm.lastUser.toString() : "User";
        }

        var modelIndex = loginScreen.usersModel.index(index, 0);
        var realName = loginScreen.usersModel.data(modelIndex, Qt.UserRole + 2);
        var name = loginScreen.usersModel.data(modelIndex, Qt.UserRole + 1);
        var edit = loginScreen.usersModel.data(modelIndex, Qt.EditRole);
        var display = loginScreen.usersModel.data(modelIndex, Qt.DisplayRole);
        var value = realName ? realName : (name ? name : (edit ? edit : display));
        var result = value ? value.toString() : "";

        if ((!result || result === "User") && sddm.lastUser) {
            return sddm.lastUser.toString();
        }
        return result || "User";
    }

    Item {
        id: loginState
        anchors.fill: parent
        visible: false
        opacity: visible ? 1 : 0
        z: 10
        property real entryProgress: 0
        Behavior on opacity { NumberAnimation { duration: 220 } }

        onVisibleChanged: {
            if (visible) {
                entryProgress = 0;
                loginEntrance.restart();
                loginScreen.syncKeyboardState();
                loginScreen.focusPassword();
            }
        }

        NumberAnimation {
            id: loginEntrance
            target: loginState
            property: "entryProgress"
            from: 0
            to: 1
            duration: 320
            easing.type: Easing.OutCubic
        }

        property bool isError: false

        SequentialAnimation {
            id: shakeAnimation
            loops: 2
            PropertyAnimation { target: loginCard; property: "x"; from: (loginScreen.width - loginCard.width)/2; to: (loginScreen.width - loginCard.width)/2 - 10; duration: 50; easing.type: Easing.InOutQuad }
            PropertyAnimation { target: loginCard; property: "x"; from: (loginScreen.width - loginCard.width)/2 - 10; to: (loginScreen.width - loginCard.width)/2 + 10; duration: 50; easing.type: Easing.InOutQuad }
            PropertyAnimation { target: loginCard; property: "x"; from: (loginScreen.width - loginCard.width)/2 + 10; to: (loginScreen.width - loginCard.width)/2; duration: 50; easing.type: Easing.InOutQuad }
            onStopped: loginState.isError = false
        }

        Rectangle {
            id: loginCard
            width: 500
            height: 430
            x: (parent.width - width) / 2
            y: (parent.height - 430) / 2 + (1 - loginState.entryProgress) * 24
            scale: 0.96 + loginState.entryProgress * 0.04
            opacity: loginState.entryProgress
            color: "transparent"
            radius: 32

            Behavior on color { ColorAnimation { duration: 200 } }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40
                spacing: 15

                Item {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 120
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle {
                        anchors.fill: parent
                        color: loginScreen.surfaceColor
                        radius: width / 2
                        visible: avatar.status !== Image.Ready

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var value = loginScreen.userNameForIndex(loginScreen.userIndex);
                                return value && value !== "User" ? value.charAt(0).toUpperCase() : "U";
                            }
                            color: loginScreen.accentColor
                            font.pixelSize: 48
                            font.family: loginScreen.boldFont
                            font.weight: Font.Bold
                        }
                    }

                    Canvas {
                        id: avatarCanvas
                        anchors.fill: parent
                        visible: avatar.status === Image.Ready

                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.reset();
                            ctx.beginPath();
                            ctx.arc(width/2, height/2, width/2, 0, 2 * Math.PI);
                            ctx.closePath();
                            ctx.clip();
                            ctx.drawImage(avatar, 0, 0, width, height);
                            console.log("Nitro SDDM: Canvas draw complete.");
                        }

                        Timer {
                            id: repaintTimer
                            interval: 500
                            onTriggered: avatarCanvas.requestPaint()
                        }

                        Image {
                            id: avatar
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                            visible: false

                            Component.onCompleted: {
                                var sourcePath = Qt.resolvedUrl("../Assets/avatar.png");
                                if (loginScreen.usersModel && loginScreen.usersModel.count > 0) {
                                    var icon = loginScreen.usersModel.data(loginScreen.usersModel.index(loginScreen.userIndex, 0), Qt.UserRole + 3);
                                    if (icon && icon.toString().match(/\.(jpg|jpeg|png|bmp|webp|svg)$/i)) {
                                        sourcePath = icon.toString();
                                    }
                                }
                                source = sourcePath;
                            }

                            onStatusChanged: {
                                if (status === Image.Ready) {
                                    console.log("Nitro SDDM: Image ready, repainting Canvas.");
                                    repaintTimer.start();
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: userNameLabel.width + 40
                    Layout.preferredHeight: userNameLabel.height + 20
                    Layout.topMargin: 10

                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        opacity: userClickArea.pressed ? 0.2 : 0
                        radius: 12
                        Behavior on opacity { NumberAnimation { duration: 100 } }
                    }

                    Text {
                        id: userNameLabel
                        anchors.centerIn: parent
                        text: {
                            if (loginScreen.usersModel && loginScreen.usersModel.count > 0) {
                                return Utils.cleanName(loginScreen.userNameForIndex(loginScreen.userIndex)) + (loginScreen.usersModel.count > 1 ? " ▾" : "");
                            }
                            return Utils.cleanName(sddm.lastUser ? sddm.lastUser : "User");
                        }
                        color: "white"
                        font.pixelSize: 24
                        font.weight: Font.Bold
                        font.family: loginScreen.regularFont
                    }

                    MouseArea {
                        id: userClickArea
                        anchors.fill: parent
                        onClicked: loginScreen.userSelectionRequested()
                    }

                    scale: userClickArea.pressed ? 0.95 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100 } }
                }

                RowLayout {
                    Layout.topMargin: 30
                    Layout.fillWidth: true
                    spacing: 10

                    TextField {
                        id: passwordField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 56
                        echoMode: TextInput.Password
                        horizontalAlignment: Text.AlignLeft
                        leftPadding: 20
                        rightPadding: 20
                        font.pixelSize: 20
                        font.family: loginScreen.regularFont
                        color: "white"
                        focus: loginState.visible
                        enabled: !loginScreen.isLoggingIn

                        Keys.onPressed: function(event) {
                            loginScreen.updateLockState(event);
                        }

                        background: Rectangle {
                            color: loginScreen.surfaceColor
                            radius: 18
                            border.width: parent.activeFocus ? 2 : 1
                            border.color: parent.activeFocus ? loginScreen.accentColor : Qt.rgba(1,1,1,0.15)
                            opacity: parent.enabled ? 1.0 : 0.5
                        }

                        Text {
                            text: "Enter password..."
                            color: "gray"
                            font.pixelSize: 18
                            font.family: loginScreen.regularFont
                            visible: !parent.text
                            anchors.verticalCenter: parent.verticalCenter
                            x: parent.leftPadding
                            opacity: 0.5
                        }

                        onAccepted: loginScreen.loginRequested()
                    }

                    RoundButton {
                        id: loginButton
                        Layout.preferredWidth: 56
                        Layout.preferredHeight: 56
                        focusPolicy: Qt.NoFocus
                        enabled: !loginScreen.isLoggingIn

                        contentItem: Text {
                            text: loginScreen.isLoggingIn ? "⋯" : "→"
                            color: "white"
                            font.pixelSize: 26
                            font.family: loginScreen.regularFont
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            color: loginScreen.isLoggingIn ? loginScreen.surfaceVariantColor : (loginButton.pressed ? Qt.darker(loginScreen.accentColor, 1.1) : loginScreen.accentColor)
                            radius: 18
                            opacity: loginScreen.isLoggingIn ? 0.5 : 1.0
                        }

                        onClicked: loginScreen.loginRequested()
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8

                    Repeater {
                        model: [
                            { label: "NUM", active: loginScreen.numLockOn },
                            { label: "CAPS", active: loginScreen.capsLockOn }
                        ]

                        delegate: Rectangle {
                            Layout.preferredWidth: 112
                            Layout.preferredHeight: 32
                            radius: 10
                            color: modelData.active ? Qt.rgba(loginScreen.accentColor.r, loginScreen.accentColor.g, loginScreen.accentColor.b, 0.2) : Qt.rgba(1, 1, 1, 0.06)
                            border.width: modelData.active ? 1 : 0
                            border.color: loginScreen.accentColor
                            opacity: loginScreen.isLoggingIn ? 0.5 : 1

                            Behavior on color { ColorAnimation { duration: 180 } }
                            Behavior on border.width { NumberAnimation { duration: 180 } }

                            Text {
                                anchors.centerIn: parent
                                text: modelData.label
                                color: modelData.active ? loginScreen.accentColor : Qt.rgba(1, 1, 1, 0.38)
                                font.pixelSize: 11
                                font.family: loginScreen.regularFont
                                font.weight: Font.Bold
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
