// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0

import com.nokia.symbian 1.0
//import com.nokia.meego 1.0

CommonDialog {
    id: dialogPrivate
    titleText: "Item options"

    signal upButtonClicked()
    signal downButtonClicked()
    signal leftButtonClicked()
    signal rightButtonClicked()
    signal deleteButtonClicked()

    property int buttonSize: 80

    content: [
        Grid {
            spacing: 5
            anchors.centerIn: parent
            rows: 3
            columns: 3

            Item { width: buttonSize; height: buttonSize }
            Button {
                id: up
                width: buttonSize; height: buttonSize
                iconSource: "qrc:/images/up.png"
                onClicked: {
                    dialogPrivate.reject()
                    upButtonClicked()
                }
            }
            Item { width: buttonSize; height: buttonSize }
            Button {
                id: prev
                width: buttonSize; height: buttonSize
                iconSource: "qrc:/images/previous.png"
                onClicked: {
                    dialogPrivate.reject()
                    leftButtonClicked()
                }
            }
            Button {
                id: del
                width: buttonSize; height: buttonSize
                iconSource: "qrc:/images/delete.png"
                onClicked: {
                    dialogPrivate.reject()
                    deleteButtonClicked()
                }
            }
            Button {
                id: next
                width: buttonSize; height: buttonSize
                iconSource: "qrc:/images/next.png"
                onClicked: {
                    dialogPrivate.reject()
                    rightButtonClicked()
                }
            }
            Item { width: buttonSize; height: buttonSize }
            Button {
                id: down
                width: buttonSize; height: buttonSize
                iconSource: "qrc:/images/down.png"
                onClicked: {
                    dialogPrivate.reject()
                    downButtonClicked()
                }
            }
        }
    ]

//    content: [
//        Item {
//            width: buttonSize*3; height: buttonSize*3
//            anchors.centerIn: parent
//            Button {
//                id: up
//                x: buttonSize; y: 0
//                width: buttonSize; height: buttonSize
//                iconSource: "qrc:/images/up.png"
//                onClicked: {
//                    dialogPrivate.reject()
//                    upButtonClicked()
//                }
//            }
//            Button {
//                id: prev
//                x: 0; y: buttonSize
//                width: buttonSize; height: buttonSize
//                iconSource: "qrc:/images/previous.png"
//                onClicked: {
//                    dialogPrivate.reject()
//                    leftButtonClicked()
//                }
//            }
//            Button {
//                id: del
//                x: buttonSize; y: buttonSize
//                width: buttonSize; height: buttonSize
//                iconSource: "qrc:/images/delete.png"
//                onClicked: {
//                    dialogPrivate.reject()
//                    deleteButtonClicked()
//                }
//            }
//            Button {
//                id: next
//                x: buttonSize * 2; y: buttonSize
//                width: buttonSize; height: buttonSize
//                iconSource: "qrc:/images/next.png"
//                onClicked: {
//                    dialogPrivate.reject()
//                    rightButtonClicked()
//                }
//            }
//            Button {
//                id: down
//                x: buttonSize; y: buttonSize*2
//                width: buttonSize; height: buttonSize
//                iconSource: "qrc:/images/down.png"
//                onClicked: {
//                    dialogPrivate.reject()
//                    downButtonClicked()
//                }
//            }
//        }
//    ]

    onClickedOutside: reject()

    buttons: [
        Button {
            text: "Cancel"
            onClicked: dialogPrivate.reject()
            anchors {
                right: parent.right; rightMargin: 15
                bottom: parent.bottom; bottomMargin: 5
            }
        }
    ]
}
