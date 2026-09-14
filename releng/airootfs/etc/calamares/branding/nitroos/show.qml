import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: presentation
    anchors.fill: parent

    property var slides: [
        "images/fastfetch.png",
        "images/nitrovim-code.png",
        "images/applauncher.png",
        "images/wallpaper-manager.png",
        "images/lockscreen.png",
        "images/feel.png",
        "images/nitrovim.png",
        "images/example.png"
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
        NumberAnimation {
            target: slideImage
            property: "opacity"
            to: 0
            duration: 300
            easing.type: Easing.InOutQuad
        }
        ScriptAction {
            script: {
                currentIndex = (currentIndex + 1) % slides.length
            }
        }
        NumberAnimation {
            target: slideImage
            property: "opacity"
            to: 1
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#0c1210"

        Item {
            anchors.fill: parent
            anchors.margins: 10
            anchors.bottomMargin: 28

            Image {
                id: slideImage
                anchors.fill: parent
                source: slides[currentIndex]
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                asynchronous: true
                opacity: 1
            }
        }

        // Clean pagination indicator dots
        Row {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 10
            }
            spacing: 6

            Repeater {
                model: slides.length
                Rectangle {
                    width: currentIndex === index ? 20 : 6
                    height: 5
                    radius: 3
                    color: currentIndex === index ? "#5aad5a" : "#1a2a1a"
                    border.color: currentIndex === index ? "#6dbf6d" : "#273d27"
                    border.width: 1

                    Behavior on width {
                        NumberAnimation { duration: 250; easing.type: Easing.OutQuad }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 250 }
                    }
                }
            }
        }
    }
}
