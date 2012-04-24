import QtQuick 1.0

Rectangle {
    id: taskButtonRect

    height: 52
    width:  100

    smooth: true
    radius: 15

    color: "transparent"

    signal clicked

    property alias text: textLabel.text
    property alias font: textLabel.font
    property alias iconSource: image.source

    property int padding: 10

    Item {
        id: contener

        anchors {
            fill: parent
        }

        Image {
            id: image
            fillMode: Image.PreserveAspectFit
            scale: ( parent.height - 2 * padding ) / height
            anchors {
                top:  parent.top
                left: parent.left
                right: textLabel.text.length > 0 ? textLabel.left : parent.right
                bottom: parent.bottom
            }
        }

        Text {
            id: textLabel
            color: "white"
            font.pixelSize: 18
            //font.pixelSize: 24 // in meego version
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            anchors {
                top:  parent.top
                left: image.source.length > 0 ? image.right : parent.left
                right: parent.right
                bottom: parent.bottom
            }
        }
    }

    Gradient {
        id: pressedGradient
        GradientStop { position: 0.0; color: "#1281dd" }
        GradientStop { position: 1.0; color: "#3091e2" }
    }

    states: State {
        when: mouseArea.pressed
        PropertyChanges {
            target:   taskButtonRect
            gradient: pressedGradient
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: taskButtonRect.clicked()
    }
}
