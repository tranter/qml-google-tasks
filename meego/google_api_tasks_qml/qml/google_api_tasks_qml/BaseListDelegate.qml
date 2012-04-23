// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0



Rectangle {
    id: delegateItemPrivate
    width: parent.width
    height: 80
    color: getColor()

    property int fontSize: 20

    signal itemIndexClicked(int index)

    function getColor() { return selected ? "#999" : (index & 1 ? window.light_color : window.dark_color) }
}
