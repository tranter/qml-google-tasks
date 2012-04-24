// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0
import com.nokia.meego 1.0

Rectangle {
    id: screenHeadRect
    width: parent.width
    height: 50
    color: "black"

    property alias headerText: screenHeadText.text
    property alias buttonVisible: optionalHeadButton.visible
    property alias buttonText: optionalHeadButton.text
    property alias buttonWidth: optionalHeadButton.width

    signal buttonClicked()

    gradient: Gradient {
        GradientStop { position: 0.0; color: "black" }
        GradientStop { position: 1.0; color: "#333" }
    }

    Item {
        id: textWrapper
        anchors { top: parent.top; bottom: parent.bottom }
        width: parent.width

        Text {
            id: screenHeadText
            color: "white"
            //font.pointSize: 24
            font.pixelSize: 32
            //horizontalAlignment: TextInput.AlignHCenter
            //verticalAlignment: TextInput.AlignLeft
            anchors.fill: parent
            anchors.leftMargin: 15
        }
    }

    Button {
        id: optionalHeadButton
        visible: false
        anchors { top: parent.top; bottom: parent.bottom; right: parent.right; margins: 5 }
        onClicked: buttonClicked()
    }
}
