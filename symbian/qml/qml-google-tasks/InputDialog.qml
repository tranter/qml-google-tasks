// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0
import com.nokia.symbian 1.0
//import com.nokia.meego 1.0


QueryDialog {
    id: inputDialog
    rejectButtonText: "Cancel"

    property alias inputText: textInput.text

    content: [
        TextField {
//        TextInput {
            id: textInput
            width: parent.width - 6
            x: 3; y: 5
            text: "";
        }
    ]

    onRejected: textInput.text = ""
}
