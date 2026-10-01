import QtQuick

Item {
    id: clock
    width: 560
    height: 900

    property string backgroundSource: ""
    property color defaultHoursColor: "#AED68A"
    property color defaultMinutesColor: "#D4E4BC"
    property string fontFamily: "CommitMono Nerd Font Mono"
    property color baseAccent: config.accentColor
    property color smartHoursColor: defaultHoursColor
    property color smartMinutesColor: defaultMinutesColor
    property string timeStr: ""
    property bool reveal: false

    function updateTime() {
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();

        if (config.use24HourClock !== "true") {
            hours = hours % 12;
            if (hours === 0) {
                hours = 12;
            }
        }

        var hStr = hours < 10 ? "0" + hours : "" + hours;
        var mStr = minutes < 10 ? "0" + minutes : "" + minutes;

        clock.timeStr = hStr + mStr;
    }

    function updateColors() {
        var base = clock.baseAccent;

        if (base.hsvSaturation < 0.15) {
            clock.smartHoursColor = Qt.lighter(base, 1.3);
            clock.smartMinutesColor = Qt.darker(base, 1.4);
            return;
        }

        if (base.hsvValue < 0.5) {
            clock.smartHoursColor = Qt.hsva(base.hsvHue, 0.7, 0.9, 1.0);
            clock.smartMinutesColor = Qt.hsva(base.hsvHue, 0.45, 0.85, 1.0);
        } else if (base.hsvValue > 0.8 && base.hsvSaturation < 0.2) {
            clock.smartHoursColor = Qt.hsva(base.hsvHue, 0.8, 0.7, 1.0);
            clock.smartMinutesColor = Qt.hsva(base.hsvHue, 0.5, 0.75, 1.0);
        } else {
            clock.smartHoursColor = Qt.hsva(base.hsvHue, Math.min(1.0, base.hsvSaturation * 1.3), 0.95, 1.0);
            clock.smartMinutesColor = Qt.hsva(base.hsvHue, Math.min(1.0, base.hsvSaturation * 0.75), 0.92, 1.0);
        }
    }

    onBaseAccentChanged: updateColors()
    Component.onCompleted: {
        updateColors();
        updateTime();
    }

    Column {
        id: clockContent
        anchors.centerIn: parent
        width: 560
        spacing: -80
        opacity: clock.reveal ? 1 : 0
        scale: clock.reveal ? 1 : 0.94
        y: clock.reveal ? 0 : 20

        Behavior on opacity { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 600; easing.type: Easing.OutBack } }
        Behavior on y { NumberAnimation { duration: 600; easing.type: Easing.OutCubic } }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
            spacing: -16
                opacity: clock.reveal ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

            Text {
                text: clock.timeStr.charAt(0)
                color: clock.smartHoursColor
                font.pixelSize: 380
                font.family: clock.fontFamily
                font.weight: Font.Bold
                width: 220
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
            Text {
                text: clock.timeStr.charAt(1)
                color: clock.smartHoursColor
                font.pixelSize: 380
                font.family: clock.fontFamily
                font.weight: Font.Bold
                width: 300
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
            spacing: -16
                opacity: clock.reveal ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }

            Text {
                text: clock.timeStr.charAt(2)
                color: "transparent"
                style: Text.Outline
                styleColor: clock.smartMinutesColor
                font.pixelSize: 380
                font.family: clock.fontFamily
                font.weight: Font.Black
                width: 220
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
            Text {
                text: clock.timeStr.charAt(3)
                color: "transparent"
                style: Text.Outline
                styleColor: clock.smartMinutesColor
                font.pixelSize: 380
                font.family: clock.fontFamily
                font.weight: Font.Black
                width: 300
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateTime()
    }
}
