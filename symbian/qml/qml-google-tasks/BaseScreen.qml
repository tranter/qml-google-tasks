import QtQuick 1.0
import com.nokia.symbian 1.1
//import com.nokia.meego 1.0


Item {
    id: baseScreen
    anchors.fill: parent

    property variant itemsList;
    property int selectedItemNum: -1

    property alias showProgressBar: progressBarRect.visible

    property alias view:     listView
    property alias model:    listViewModel
    property alias delegate: listView.delegate
    property alias headText: screenHeadRect.headerText

//    property alias backButtonText: backButton.text

    signal itemIndexClicked(int index)

    signal backButtonClicked()
    signal refreshButtonClicked()
    signal createTriggered(string text)

    signal removeTriggered(string id)
//    signal menuButtonClicked()
//    signal deleteItemTriggered()

    signal headerButtonClicked()

    onRefreshButtonClicked: showProgressBar = true
    onRemoveTriggered:      showProgressBar = true
    onCreateTriggered:      showProgressBar = true

    function clearContents()
    {
        setSelectedItem(-1)
        itemsList = undefined
    }

    function isValidItemNum(itemNum) {
        return -1 < itemNum && itemNum < listViewModel.count;
    }

    function isValidSelecteedItemNum() {
        return isValidItemNum(selectedItemNum)
    }

    function setSelectedItem(slectedNum, selected)
    {
        if( isValidSelecteedItemNum() )
            listViewModel.get(selectedItemNum)["selected"] = false;

        // switching select
        // selectedItemNum = selectedItemNum == slectedNum ? -1 : slectedNum;
        selectedItemNum = slectedNum;

        if( isValidSelecteedItemNum() )
            listViewModel.get(selectedItemNum)["selected"] = selected;
    }

    function showInfoMessage(message) {
        infoDialog.message = message + "\n" // ?!
        infoDialog.open()
    }

    function showDeleteMessage(message) {
        queryDialog.message = message + "\n" // ?!
        queryDialog.open()
    }

    function enablButton(b_text, b_width) {
        screenHeadRect.buttonVisible = true
        screenHeadRect.buttonText = b_text
        if( b_width > 0 )
            screenHeadRect.buttonWidth = b_width
    }

    QueryDialog {
        id: queryDialog
        acceptButtonText: "Yes"
        rejectButtonText: "No"
        titleText: "Delete"

        onAccepted: removeTriggered( listViewModel.get(selectedItemNum)["id"] )
    }

    QueryDialog {
        id: infoDialog
        rejectButtonText: "Close"
        titleText: "Information"
    }

    InputDialog {
        id: inputDialog
        titleText: "New tasks list"

        acceptButtonText: "Add"

        onAccepted: {
            if( inputText.length ) {
                createTriggered( inputText )
                inputText = ""
            }
        }
    }

    HeaderRectangle {
        id: screenHeadRect
        width: parent.width

        anchors { left:  parent.left; right: parent.right; top: parent.top }

        onButtonClicked: headerButtonClicked()
    }

    Rectangle {
        id: backgroundListView
        anchors { left: parent.left; right: parent.right; bottom: toolBar.top; top: screenHeadRect.bottom }
        color: "black"
        z: -1

        ListView {
            id: listView
            model: listViewModel
            anchors.fill: parent
        }
    }


    FooterRectangle
    {
        id: toolBar
        anchors.bottom: parent.bottom

        TaskToolButton {
            id: backButton
            iconSource: "qrc:/images/prev-view.png"
            onClicked: backButtonClicked()
            width: 120
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        TaskToolButton {
            iconSource: "qrc:/images/add.png"
            onClicked: inputDialog.open()
            width: 120
            anchors.centerIn: parent
        }

        TaskToolButton {
            iconSource: "qrc:/images/refresh.png"
            onClicked: refreshButtonClicked()
            width: 120
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Rectangle {
        id: progressBarRect
        visible: true
        color: "black"
        anchors { left: parent.left; right: parent.right; bottom: toolBar.top; top: screenHeadRect.bottom }

        ProgressBar {
            id: progressBar
            indeterminate: true
            visible: true
            height: 20
            anchors.centerIn: parent
        }
    }

    ListModel {
        id: listViewModel
    }
}
