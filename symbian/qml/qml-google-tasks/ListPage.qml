import QtQuick 1.0
import com.nokia.symbian 1.1
//import com.nokia.meego 1.0

import "tasks_data_manager.js" as TasksDataManager

BaseScreen {
    id: listPage
    anchors.fill: parent
    delegate: listViewDelegate

    onRemoveTriggered: {
        if( isValidSelecteedItemNum() )
            TasksDataManager.deleteList( model.get(selectedItemNum)["id"] )
    }

    onCreateTriggered: TasksDataManager.createList(text)

    onBackButtonClicked: Qt.quit()

    onRefreshButtonClicked: {
        setSelectedItem(-1, false)
        TasksDataManager.getMyTaskLists()
    }

    onItemsListChanged:
    {
        var lastY = view.contentY
        showProgressBar = false

        model.clear()
        if(itemsList === undefined)
            return

        for(var i = 0; i < itemsList.length; ++i)
        {
            console.log("append:", itemsList[i]["title"], itemsList[i]["id"]);
            var item = itemsList[i]
            item["selected"] = selectedItemNum === i
            model.append( item );
        }

        view.contentY = lastY
    }

    Component {
        id: listViewDelegate

        BaseListDelegate
        {
            onItemIndexClicked:
            {
                listPage.itemIndexClicked(index)
                listPage.setSelectedItem(index, true)
            }

//            Button {
            TaskButton {
                id: button
                iconSource: "qrc:/images/edit.png"
                height: parent.height - 20
                width: height
                anchors { left: parent.left; leftMargin: 10; top: parent.top; topMargin: 10 }
                onClicked: {
                    setSelectedItem(index, true)
                    openMenu()
                }
            }

            Text {
                id: textItem
                text: title
                color: "white"
                //font.pixelSize: fontSize
                font.pixelSize: fontPixelSize
                x: 10
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                anchors { left: button.right; leftMargin: 10 }
            }

            MouseArea {
                anchors {
                    left:   textItem.left
                    leftMargin: 10
                    top:    parent.top
                    bottom: parent.bottom
                    right:  parent.right
                }

                onClicked: itemIndexClicked(index)
            }
        }
    }

    Menu {
        id: mainMenu
        content: MenuLayout {
            MenuItem {
                text: "Change list name";
                onClicked: {
                    editDialog.inputText = model.get(selectedItemNum)["title"]
                    editDialog.open()
                }
            }
            MenuItem {
                text: "Clear all completed tasks"
                onClicked: queryDialog.open()
            }
            MenuItem {
                text: "Delete list"
                onClicked: showDeleteMessage("Delete: \""+model.get(selectedItemNum)["title"]+"\" list?")
            }
        }
    }

    InputDialog {
        id: editDialog
        titleText: "Edit list name"
        acceptButtonText: "Save"
        onAccepted:
        {
            if( ! inputText.length ) return

            var json = JSON.stringify( model.get(selectedItemNum) ) // creating copy
            var item = JSON.parse(json)

            item["selected"] = undefined // use in ListView to show selecting
            item["title"]    = inputText

            showProgressBar = true
            TasksDataManager.updateTaskList(item["id"], item)
        }
    }

    QueryDialog {
        id: queryDialog
        acceptButtonText: "Yes"
        rejectButtonText: "No"
        titleText: "Clear"
        message: "Clear all completed tasks?\n"

        onAccepted: TasksDataManager.clearTasks( model.get(selectedItemNum)["id"] )
    }

    function openMenu()
    {
        if( ! isValidSelecteedItemNum() )
        {
            showInfoMessage("Select item")
            return
        }

        mainMenu.open()
    }
}
