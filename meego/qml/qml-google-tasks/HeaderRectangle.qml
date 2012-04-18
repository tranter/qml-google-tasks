// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0

Rectangle {
    id: screenHeadRect
    width: parent.width
    height: 50
    color: "black"

    property alias headerText: screenHeadText.text

    gradient: Gradient {
        GradientStop { position: 0.0; color: "black" }
        GradientStop { position: 1.0; color: "#333" }
    }

    Text {
        id: screenHeadText
        color: "white"
        font.pointSize: 24
        horizontalAlignment: TextInput.AlignHCenter
        anchors.fill: parent
    }
}
