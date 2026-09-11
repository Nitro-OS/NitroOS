import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: presentation
    anchors.fill: parent

    property var slides: [
        "images/applauncher.png",
        "images/example.png",
        "images/fastfetch.png",
        "images/feel.png",
        "images/lockscreen.png",
        "images/nitrovim-code.png",
        "images/nitrovim.png",
        "images/wallpaper-manager.png"
    ]
    property int currentIndex: 0

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: fadeOut.start()
    }

    SequentialAnimation {
        id: fadeOut
        NumberAnimation { target: slideImage; property: "opacity"; to: 0; duration: 350; easing.type: Easing.InQuad }
        ScriptAction { script: { currentIndex = (currentIndex + 1) % slides.length } }
        NumberAnimation { target: slideImage; property: "opacity"; to: 1; duration: 350; easing.type: Easing.OutQuad }
    }

    Rectangle {
        anchors.fill: parent
        color: "#0c1210"

        Image {
            id: slideImage
            anchors.fill: parent
            source: slides[currentIndex]
            fillMode: Image.PreserveAspectCrop
            smooth: true
            mipmap: true
            opacity: 1
        }

        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.4
        }

        ColumnLayout {
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                bottomMargin: 32
                leftMargin: 32
                rightMargin: 32
            }
            spacing: 8

            RowLayout {
                spacing: 10

                Image {
                    source: "icon.png"
                    width: 26
                    height: 26
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }

                Text {
                    text: "Installing NitroOS"
                    font.family: "Inter, Noto Sans, sans-serif"
                    font.pixelSize: 18
                    font.weight: Font.SemiBold
                    color: "#e8f5e9"
                }
            }

            Text {
                text: "Super Fast | Minimal | Arch-based | Powered by NitroBrain"
                font.family: "Inter, Noto Sans, sans-serif"
                font.pixelSize: 10
                color: "#8ab890"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Row {
                spacing: 5

                Repeater {
                    model: slides.length
                    Rectangle {
                        width: currentIndex === index ? 16 : 5
                        height: 5
                        radius: 3
                        color: currentIndex === index ? "#5aad5a" : "#2e4030"
                        Behavior on width { NumberAnimation { duration: 300 } }
                    }
                }
            }
        }
    }
}
