// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0
//import com.nokia.symbian 1.0
import com.nokia.meego 1.0
import com.nokia.extras 1.1

import ICS 1.0

import "tasks_data_manager.js" as TasksDataManager
import "json2.js" as JSON

Rectangle
{
    id: taskEditScreenPrivate
    anchors.fill: parent
    color: "black"

    property variant currentItem: {"kind": "tasks#task"}

    signal backButtonClicked()

    QueryDialog {
        id: infoDialog
        rejectButtonText: "Close"
        titleText: "Information"
        message: "Select item to delete\n"
    }

    DateTimeConverter { id: dateConverter }

    function saveButtonClicked()
    {
        var dueDateString = undefined

        if( checkBoxDueDate.checked )
        {
            dateConverter.setHumanable( dueDate.text )
            dueDateString = dateConverter.toRFC3339()
        }

        var item = currentItem
        // working on currentItem does not give the expected result // ??

        item["title"] = title.text
        item["notes"] = textArea.text
        item["due"] = dueDateString

        if( checkBox.checked )
        {
            item["status"] = "completed"
        } else {
            item["status"] = "needsAction"
            item["completed"] = undefined
        }

        if( tasksListPage.currentListId.length )
            TasksDataManager.updateTask(tasksListPage.currentListId, item["id"], item)
    }

    function setItem( item )
    {
        currentItem = item

        screenHeadRect.headerText = "Edited task: " + currentItem["title"]
        checkBox.checked = currentItem["status"] === "completed"
        title.text = currentItem["title"]
        textArea.text = currentItem["notes"] || ""

        checkBoxDueDate.checked = currentItem["due"] !== undefined
        dueDate.visible = checkBoxDueDate.checked

        if( checkBoxDueDate.checked )
            dateConverter.setRFC3339( currentItem["due"] )
        else
            dateConverter.setToday()

        dueDate.text = dateConverter.toHumanableFormat()
    }

    HeaderRectangle {
        id: screenHeadRect
        width: parent.width

        anchors { left:  parent.left; right: parent.right; top: parent.top }
    }


        Item {
            id: subItem

            anchors {
                left: parent.left
                right: parent.right
                top: screenHeadRect.bottom
                bottom: toolBar.top
                margins: 10
            }

            CheckBox {
                id: checkBox
                anchors { left: parent.left; top: parent.top }
            }
            TextField {
                id: title
                height: checkBox.height
                anchors { left: checkBox.right; top: parent.top; right: parent.right }
            }

            CheckBox {
                id: checkBoxDueDate
                text: ""
                anchors { left: parent.left; top: checkBox.bottom; topMargin: 15 }
                onCheckedChanged: dueDate.visible = checked
            }

            Text {
                id: dueDateText
                text: "Due date:"
                //font.pointSize: 24
                font.pixelSize: 32
                anchors { left: checkBoxDueDate.right;  verticalCenter: checkBoxDueDate.verticalCenter }
                color: "white"
            }

//            TextField {
//                id: dueDate
//                height: checkBoxDueDate.height
//                anchors { left: checkBoxDueDate.right; right: parent.right; top: checkBox.bottom; topMargin: 5; leftMargin: 5 }
//            }

            TaskButton {
                id: dueDate
                text: "Select date"
                anchors { left: dueDateText.right; right: parent.right; top: checkBox.bottom; topMargin: 15; leftMargin: 5 }
                onClicked: { dateDialog.setDate(currentItem["due"]); dateDialog.open() }
            }

            Text {
                id: textNotes
                text: "Notes:"
                //font.pointSize: 24
                font.pixelSize: 32
                anchors { left: parent.left; right: parent.right; top: dueDate.bottom; topMargin: 15 }
                color: "white"
            }

            TextArea {
                id: textArea
                anchors { left: parent.left; right: parent.right; top: textNotes.bottom; bottom: parent.bottom }
            }
        }

    FooterRectangle
    {
        id: toolBar

        anchors.bottom: parent.bottom

        TaskToolButton {
            iconSource: "qrc:/images/prev-view.png"
            width: 120
            onClicked: backButtonClicked()
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        TaskToolButton {
            text: "Save"
            width: 120
            onClicked: saveButtonClicked()
            anchors.right: refreshButton.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        TaskToolButton {
            id: refreshButton
            text: "Refresh"
            width: 120
            onClicked: TasksDataManager.getTask( tasksListPage.currentListId, currentItem["id"] )
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    DatePickerDialog {
        id: dateDialog
        titleText: "Select Date"
        acceptButtonText: "OK"
        rejectButtonText: "Cancel"

        onAccepted: dueDate.text = dateDialog.getDate()

        function getDate() {
            dateConverter.setDate(year, month, day)
            return dateConverter.toHumanableFormat()
        }

        function setDate(RFC3339)
        {
            if( RFC3339 === undefined )
                dateConverter.setToday()
            else
                dateConverter.setRFC3339(RFC3339)

            year  = dateConverter.year()
            month = dateConverter.month()
            day   = dateConverter.day()
        }
    }
}
