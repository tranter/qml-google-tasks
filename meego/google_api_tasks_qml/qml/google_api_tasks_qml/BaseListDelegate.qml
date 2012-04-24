// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0



Rectangle {
    id: delegateItemPrivate
    width: parent.width
    height: 80
    color: getColor()

    //property int fontSize: 20
    property int fontPixelSize: 28

    signal itemIndexClicked(int index)

    function getColor() { return selected ? "#999" : (index & 1 ? pageStack.light_color : pageStack.dark_color) }
}
