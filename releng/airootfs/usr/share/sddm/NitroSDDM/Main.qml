import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "Components"

Rectangle {
    id: container
    width: 1920
    height: 1080
    color: config.backgroundColor
    focus: !loginScreen.loginVisible

    property int userIndex: 0
    property int sessionIndex: 0
    property bool isLoggingIn: false

    Component.onCompleted: {
        if (typeof userModel !== "undefined" && userModel.lastIndex >= 0) {
            userIndex = userModel.lastIndex;
        }
        if (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) {
            sessionIndex = sessionModel.lastIndex;
        }
    }

    function doLogin() {
        if (!loginScreen.loginVisible || isLoggingIn) {
            return;
        }

        var user = "";
        if (typeof userModel !== "undefined" && userModel.count > 0) {
            var idx = container.userIndex;
            if (idx < 0 || idx >= userModel.count) {
                idx = 0;
            }

            var edit = userModel.data(userModel.index(idx, 0), Qt.EditRole);
            var nameRole = userModel.data(userModel.index(idx, 0), Qt.UserRole + 1);
            var display = userModel.data(userModel.index(idx, 0), Qt.DisplayRole);

            user = edit ? edit.toString() : (nameRole ? nameRole.toString() : (display ? display.toString() : ""));
        }

        if (!user || user === "" || user === "User") {
            user = sddm.lastUser;
        }

        if (!user && typeof userModel !== "undefined" && userModel.count > 0) {
            var firstEdit = userModel.data(userModel.index(0, 0), Qt.EditRole);
            user = firstEdit ? firstEdit.toString() : "";
        }

        if (!user) {
            return;
        }

        container.isLoggingIn = true;
        var pass = loginScreen.passwordText;
        var sess = container.sessionIndex;

        if (typeof sessionModel !== "undefined") {
            if (sess < 0 || sess >= sessionModel.count) {
                sess = 0;
            }
        } else {
            sess = 0;
        }

        console.log("Nitro SDDM: Attempting login for user [" + user + "] session index [" + sess + "]");
        sddm.login(user.trim(), pass, sess);
        loginTimeout.start();
    }

    Timer {
        id: loginTimeout
        interval: 5000
        onTriggered: container.isLoggingIn = false
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            container.isLoggingIn = false
            loginTimeout.stop()
            loginScreen.showError()
        }
        function onLoginSucceeded() {
            loginTimeout.stop()
        }
    }

    property color extractedAccent: config.accentColor
    property color baseColor: config.backgroundColor
    property color surfaceColor: Qt.lighter(baseColor, 1.3)
    property color surfaceVariantColor: Qt.lighter(baseColor, 1.6)
    property bool uiReady: config.autoColor !== "true" || colorExtractor.processed

    Timer {
        id: colorDelay
        interval: 1000
        repeat: true
        running: backgroundImage.status === Image.Ready && !colorExtractor.processed && config.autoColor === "true"
        onTriggered: colorExtractor.requestPaint()
    }

    Canvas {
        id: colorExtractor
        width: 60; height: 60
        x: -100; y: -100
        z: -1
        renderTarget: Canvas.Image
        property bool processed: false
        property int retries: 0

        onPaint: {
            var ctx = getContext("2d");
            var res = 60;
            ctx.clearRect(0, 0, res, res);
            ctx.drawImage(backgroundImage, 0, 0, res, res);
            var imgData = ctx.getImageData(0, 0, res, res).data;

            if (!imgData || imgData.length === 0) {
                return;
            }

            var histogram = new Array(36).fill(0);
            var sampleColors = new Array(36).fill(null);
            var vibrantFound = false;

            var pixelSum = 0;
            for (var p = 0; p < imgData.length; p++) pixelSum += imgData[p];

            if (pixelSum === 0) {
                retries++;
                if (retries > 3) {
                    container.extractedAccent = "#D0D0D0";
                    console.log("Nitro SDDM: Pure black wallpaper detected. Using neutral contrast.");
                    processed = true;
                }
                return;
            }

            retries = 0;

            for (var i = 0; i < imgData.length; i += 4) {
                var r = imgData[i] / 255;
                var g = imgData[i+1] / 255;
                var b = imgData[i+2] / 255;
                var pCol = Qt.rgba(r, g, b, 1.0);

                if (pCol.hsvSaturation > 0.3 && pCol.hsvValue > 0.15) {
                    var h = pCol.hsvHue * 360;
                    if (h < 0) {
                        continue;
                    }

                    var bIdx = Math.floor(h / 10) % 36;
                    var weight = pCol.hsvSaturation * pCol.hsvValue;
                    histogram[bIdx] += weight;

                    if (!sampleColors[bIdx] || weight > (sampleColors[bIdx].hsvSaturation * sampleColors[bIdx].hsvValue)) {
                        sampleColors[bIdx] = pCol;
                    }
                    vibrantFound = true;
                }
            }

            if (!vibrantFound) {
                var totalBrightness = 0;
                var pixelCount = imgData.length / 4;
                for (var k = 0; k < imgData.length; k += 4) {
                    var r_l = imgData[k] / 255;
                    var g_l = imgData[k+1] / 255;
                    var b_l = imgData[k+2] / 255;
                    totalBrightness += (0.299 * r_l + 0.587 * g_l + 0.114 * b_l);
                }
                var avgBrightness = totalBrightness / pixelCount;

                container.extractedAccent = avgBrightness < 0.5 ? "#D0D0D0" : "#404040";
                console.log("Nitro SDDM: No vibrant colors. Avg brightness: " + avgBrightness.toFixed(2) + ". Using neutral contrast.");
                processed = true;
                return;
            }

            histogram[0] += histogram[35];

            var maxCount = -1;
            var winnerIdx = -1;
            for (var j = 0; j < 35; j++) {
                if (histogram[j] > maxCount) {
                    maxCount = histogram[j];
                    winnerIdx = j;
                }
            }

            if (winnerIdx !== -1 && sampleColors[winnerIdx]) {
                var finalColor = sampleColors[winnerIdx];
                var h = finalColor.hsvHue;
                var s = Math.max(0.35, Math.min(0.55, finalColor.hsvSaturation * 0.9));
                container.extractedAccent = Qt.hsva(h, s, 0.95, 1.0);
                console.log("Nitro SDDM: SUCCESS! Extracted Hue: " + (h * 360).toFixed(0) + "°");
                processed = true;
            }
        }
    }

    Connections {
        target: backgroundImage
        function onStatusChanged() {
            if (backgroundImage.status === Image.Ready) {
                colorExtractor.processed = false;
                colorDelay.start();
            }
        }
    }

    FontLoader { id: fontRegular; source: "Assets/fonts/CommitMonoNerdFontMono-Regular.otf" }
    FontLoader { id: fontBold; source: "Assets/fonts/CommitMonoNerdFontMono-Bold.otf" }

    property var availableFonts: Qt.fontFamilies()
    property string activeFontRegular: (config.fontFamily && config.fontFamily.length > 0 && availableFonts.indexOf(config.fontFamily) >= 0) ? config.fontFamily : fontRegular.name
    property string activeFontBold:    (config.fontFamily && config.fontFamily.length > 0 && availableFonts.indexOf(config.fontFamily) >= 0) ? config.fontFamily : fontBold.name

    Image {
        id: backgroundImage
        source: config.background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    MultiEffect {
        id: backgroundBlur
        anchors.fill: parent
        source: backgroundImage
        blurEnabled: true
        blur: loginScreen.loginVisible ? 1.0 : 0.0
        opacity: loginScreen.loginVisible ? 1.0 : 0.0
        autoPaddingEnabled: false

        Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.InOutQuad } }
        Behavior on blur { NumberAnimation { duration: 400; easing.type: Easing.InOutQuad } }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: loginScreen.loginVisible ? 0.6 : 0.4
        Behavior on opacity { NumberAnimation { duration: 400 } }
    }

    PowerBar {
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 30
            rightMargin: 40
        }
        textColor: container.extractedAccent
        surfaceColor: container.surfaceColor
        accentColor: container.extractedAccent
        z: 100
        opacity: container.uiReady ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    Shortcut {
        sequence: "Escape"
        enabled: loginScreen.loginVisible
        onActivated: {
            loginScreen.loginVisible = false;
            loginScreen.clearError();
            loginScreen.passwordText = "";
            container.focus = true;
        }
    }

    Shortcut {
        sequences: ["Return", "Enter"]
        enabled: loginScreen.loginVisible
        onActivated: container.doLogin()
    }

    DatePill {
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 28
            leftMargin: 40
        }
        accentColor: container.extractedAccent
        surfaceColor: container.surfaceColor
        fontFamily: container.activeFontRegular
        contentReady: container.uiReady
    }

    LockScreen {
        id: lockState
        visible: !loginScreen.loginVisible
        backgroundSource: config.background
        accentColor: container.extractedAccent
        textColor: config.textColor
        fontFamily: container.activeFontRegular
        contentReady: container.uiReady
        onUnlockRequested: {
            loginScreen.loginVisible = true;
            loginScreen.focusPassword();
        }
    }

    SessionSelector {
        id: sessionSelector
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 40
            bottomMargin: 40
        }
        sessionsModel: typeof sessionModel !== "undefined" ? sessionModel : null
        currentIndex: container.sessionIndex
        loginVisible: loginScreen.loginVisible
        accentColor: container.extractedAccent
        surfaceColor: container.surfaceColor
        surfaceVariantColor: container.surfaceVariantColor
        regularFont: container.activeFontRegular
        z: 20
        onSelectionRequested: sessionPopup.open()
    }

    LoginScreen {
        id: loginScreen
        usersModel: typeof userModel !== "undefined" ? userModel : null
        userIndex: container.userIndex
        isLoggingIn: container.isLoggingIn
        accentColor: container.extractedAccent
        surfaceColor: container.surfaceColor
        surfaceVariantColor: container.surfaceVariantColor
        regularFont: container.activeFontRegular
        boldFont: container.activeFontBold
        onLoginRequested: container.doLogin()
        onUserSelectionRequested: userPopup.open()
    }

    Keys.onPressed: function(event) {
        if (!loginScreen.loginVisible) {
            loginScreen.loginVisible = true;
            loginScreen.focusPassword();
            event.accepted = true;
        }
    }

    SelectionPopup {
        id: userPopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2 - 50
        selectionModel: typeof userModel !== "undefined" ? userModel : null
        currentIndex: container.userIndex
        baseColor: container.baseColor
        surfaceColor: container.surfaceColor
        surfaceVariantColor: container.surfaceVariantColor
        accentColor: container.extractedAccent
        regularFont: container.activeFontRegular
        boldFont: container.activeFontBold
        onIndexSelected: function(index) { container.userIndex = index }
    }

    SelectionPopup {
        id: sessionPopup
        x: 40
        y: parent.height - height - 100
        sessionMode: true
        selectionModel: typeof sessionModel !== "undefined" ? sessionModel : null
        currentIndex: container.sessionIndex
        baseColor: container.baseColor
        surfaceColor: container.surfaceColor
        surfaceVariantColor: container.surfaceVariantColor
        accentColor: container.extractedAccent
        regularFont: container.activeFontRegular
        onIndexSelected: function(index) { container.sessionIndex = index }
    }
}
