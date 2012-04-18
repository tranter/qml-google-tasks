// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0

Rectangle {
    id: footerRect
    width: parent.width
    height: 60

    color: "black"

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#333" }
        GradientStop { position: 1.0; color: "black" }
    }
}
