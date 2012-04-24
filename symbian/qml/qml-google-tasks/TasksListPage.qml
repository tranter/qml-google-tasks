// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0
import com.nokia.symbian 1.1
//import com.nokia.meego 1.0

import "tasks_data_manager.js" as TasksDataManager

BaseScreen {
    id: tasksListPage
    anchors.fill: parent
    delegate: listViewDelegate
//    backButtonText: "Lists"

    property string currentListId: ""

    onCurrentListIdChanged: refreshCurrentTasks()

//    onDeleteItemTriggered: showDeleteMessage("Delete selected task?")

    property bool useDialog: false

    onRemoveTriggered:
    {
        if( ! isValidSelecteedItemNum() )
            return
        var selectedItem = model.get(selectedItemNum)

        TasksDataManager.deleteTask( currentListId, selectedItem["id"] )
    }

    onCreateTriggered:
    {
        var prevTaskId = undefined
        var parentTaskId = undefined

        var selectedItem = undefined

        if( isValidSelecteedItemNum() )
            selectedItem = model.get(selectedItemNum)
        else if( model.count )
            selectedItem = model.get(model.count - 1)

        if( selectedItem !== undefined )
        {
            prevTaskId   = selectedItem["id"]
            parentTaskId = selectedItem["tasks_parent"]
        }

        TasksDataManager.createTask(currentListId, text, prevTaskId, parentTaskId)
    }

    onRefreshButtonClicked: refreshCurrentTasks()

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
            item["selected"] = false // ... ?!
            item["selected"] = selectedItemNum === i
            item["tasks_parent"] = item["parent"] // copy, cause items in list have own parent
            model.append( item )
        }

        view.contentY = lastY
    }

    function refreshCurrentTasks()
    {
        setSelectedItem(-1, false)
        if( currentListId.length ) TasksDataManager.getMyTasks(currentListId)
    }

    function setCheckedItem(index, checked)
    {
        var json = JSON.stringify( model.get(index) ) // creating copy
        var item = JSON.parse(json)

        item["status"]       = (checked ? "completed" : "needsAction")
        item["completed"]    = undefined

        item["selected"]     = undefined // use in ListView to show selecting
        item["parent"]       = item["tasks_parent"]
        item["tasks_parent"] = undefined

        TasksDataManager.updateTask(currentListId, item["id"], item)
    }

    Component {
        id: listViewDelegate

        BaseListDelegate
        {
            id: delegateItem

            property int indentUnit: 20

//            imageUrl: "qrc:/images/move.png"

            onItemIndexClicked: {
                tasksListPage.setSelectedItem(index, true)
                tasksListPage.openMenu()
            }

            MouseArea {
                id: outerCheckBoxWrapper
                anchors {
                    top: parent.top
                    left: parent.left
                }
                width: delegateCheckBox.x + delegateCheckBox.width + 20
                height: parent.height

                onPressed: delegateCheckBox.pressed = true
                onClicked: {
                    delegateCheckBox.checked = ! delegateCheckBox.checked
                    checkBoxClicked()
                }
                onReleased: delegateCheckBox.pressed = false
            }

            CheckBox {
                id: delegateCheckBox
                checked: status === "completed"

                y: (parent.height - height) * 0.5

                anchors {
                    left: parent.left
                    leftMargin: 10
                }
                onClicked: checkBoxClicked()
            }

            function checkBoxClicked()
            {
                setSelectedItem( index, true )
                setCheckedItem(  index, delegateCheckBox.checked )
            }

            Text { // CheckBox diaplay text, but not anytime ?!
                id: textItem
                text: title
                //font.pixelSize: fontSize
                font.pixelSize: fontPixelSize
                color: "white"
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                anchors { left: delegateCheckBox.right; leftMargin: 20; right: button.left; rightMargin: 5 }
            }

            TaskButton {
                id: button
                iconSource: "qrc:/images/next-view.png"
                height: parent.height - 20
                width: height
                anchors { right: parent.right; rightMargin: 10; top: parent.top; topMargin: 10 }
                onClicked: {
                    setSelectedItem(index, true)
                    tasksListPage.itemIndexClicked(index)
                }
            }

            MouseArea {
                anchors {
                    left:   textItem.left
                    leftMargin: 10
                    top:    parent.top
                    bottom: parent.bottom
                    right:  button.left
                    rightMargin: 10
                }

                onClicked: itemIndexClicked(index)
            }

            Component.onCompleted:
            {
                var indent = 10 // base left margin
                if( tasks_parent === undefined )
                    return indent;

                var root = tasks_parent
                var i = index-1
                while( -1 < i )
                {
                    if( root == tasksListPage.model.get(i)["id"] )
                    {
                        indent += indentUnit
                        root = tasksListPage.model.get(i)["tasks_parent"]
                        if( root === undefined )
                            break
                    }
                    --i
                }
                delegateCheckBox.anchors.leftMargin = indent
            }
        }
    }

    Menu {
        id: mainMenu
        content: MenuLayout {
            MenuItem { text: "Move up";         onClicked: moveUpSelectedItem()      }
            MenuItem { text: "Move down";       onClicked: moveDownSelectedItem()    }
            MenuItem { text: "Move to left";    onClicked: moveToLeftSelectedItem()  }
            MenuItem { text: "Move to right";   onClicked: moveToRightSelectedItem() }

            MenuItem { text: "Delete item";     onClicked: showDeleteMessage("Delete task: \""+model.get(selectedItemNum)["title"]+"\"?") }
        }
    }

//    TasksDialog {
//        id: tasksDialog
//        onUpButtonClicked:      moveUpSelectedItem()
//        onDownButtonClicked:    moveDownSelectedItem()
//        onLeftButtonClicked:    moveToLeftSelectedItem()
//        onRightButtonClicked:   moveToRightSelectedItem()
//        onDeleteButtonClicked:  showDeleteMessage("Delete task: \""+model.get(selectedItemNum)["title"]+"\"?")
//    }

    function openMenu()
    {
        if( ! isValidSelecteedItemNum() )
        {
            showInfoMessage("Select item to move")
            return
        }

        if( ! useDialog )
            mainMenu.open()
//        else
//            tasksDialog.open()
    }

    function moveUpSelectedItem()
    {
        if( ! selectedItemNum ) return

        var parent = model.get(selectedItemNum)["tasks_parent"]
        // find upper neighbor
        var i = selectedItemNum-1
        while( -1 < i && parent != tasksListPage.model.get(i)["tasks_parent"] )
            --i
        if( i < 0 ) return

        TasksDataManager.moveTask(currentListId, tasksListPage.model.get(i)["id"], tasksListPage.model.get(selectedItemNum)["id"], parent)
        --selectedItemNum
    }

    function moveDownSelectedItem()
    {
        var size = model.count
        if( selectedItemNum + 1 == model.count ) return

        var tasks_parent = model.get(selectedItemNum)["tasks_parent"]
        // find downer neighbor
        var i = selectedItemNum+1
        while( i < size && tasks_parent != model.get(i)["tasks_parent"] )
            ++i
        if(i == size) return

        TasksDataManager.moveTask(currentListId, model.get(selectedItemNum)["id"], model.get(i)["id"], tasks_parent )
        ++selectedItemNum
    }

    function moveToLeftSelectedItem()
    {
        var item = model.get(selectedItemNum)
        var tasks_parent = item["tasks_parent"]
        if( tasks_parent === undefined )
            return

        // going to parent, and get his parent
        var i = selectedItemNum-1
        while( -1 < i && tasks_parent != tasksListPage.model.get(i)["id"] )
            --i

        tasks_parent =  i < 0 ? "" : tasksListPage.model.get(i)["tasks_parent"]

        TasksDataManager.moveTask(currentListId, item["id"], item["tasks_parent"], tasks_parent )
        console.log("move to left", item["id"], item["tasks_parent"], tasks_parent )
    }

    function moveToRightSelectedItem()
    {
        if( ! selectedItemNum ) return

        var tasks_parent = model.get(selectedItemNum)["tasks_parent"]
        if( tasks_parent == model.get(selectedItemNum-1)["id"] )
            return

        // finding parent
        var i = selectedItemNum-1
        while( -1 < i && tasks_parent != tasksListPage.model.get(i)["tasks_parent"] )
            --i
        tasks_parent = i < 0 ? "" : tasksListPage.model.get(i)["id"]

        // finding previous // first item with parent as tasks_parent
        i = selectedItemNum-1
        while( -1 < i && tasks_parent != tasksListPage.model.get(i)["tasks_parent"] )
            --i
        var prevID = i < 0 ? "" : tasksListPage.model.get(i)["id"]

        TasksDataManager.moveTask(currentListId, model.get(selectedItemNum)["id"], prevID, tasks_parent )
        console.log("move to right", model.get(selectedItemNum)["id"], prevID, tasks_parent )
    }

}
