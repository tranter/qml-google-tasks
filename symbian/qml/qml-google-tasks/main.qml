import QtQuick 1.0
import com.nokia.symbian 1.1
//import com.nokia.meego 1.0

import ICS 1.0
import "tasks_data_manager.js" as TasksDataManager
import "json2.js" as JSON

PageStackWindow { // 1.1

    id: pageStack
    anchors.fill: parent

    property color light_color: "#333"
    property color dark_color: "black"

    initialPage: listPage // 1.1

    showStatusBar: false // 1.1
    showToolBar: false // 1.1

    DeleteTasksDataManager {
        id: deleteTasksDataManager
        // All delete function is call in tasks_data_manager.js
        // on this object. Currently it's only wrapper for non worked
        // method: DELETE on XMLHttpRequest objects

        onListsChanged: TasksDataManager.getMyTaskLists()
        onTaskChanged: {
            if( tasksListPage.currentListId.length )
                TasksDataManager.getMyTasks(tasksListPage.currentListId)
        }
    }

    ListPage {
        id: listPage
        anchors.fill: parent
        headText: "Tasks Lists"

        onItemIndexClicked:
        {
            tasksListPage.showProgressBar = true
            var item = model.get(index)
            tasksListPage.headText = "Tasks list: " + item["title"]
            tasksListPage.clearContents()
            tasksListPage.currentListId = item["id"]
            pageStack.pageStack.push(tasksListPage)
        }

        Component.onCompleted: enablButton("Login", 100)

        onHeaderButtonClicked: {
            google_oauth.login()
            google_oauth.visible = true
        }
    }

    TasksListPage {
        id: tasksListPage
        anchors.fill: parent
        visible: false

        onBackButtonClicked: {
            tasksListPage.clearContents()
            tasksListPage.currentListId = ""
            pageStack.pageStack.pop()
        }

        onItemIndexClicked:
        {
            var json = JSON.stringify( model.get(index) ) // creating copy
            var item = JSON.parse(json)

            item["selected"] = undefined // used in ListView to show selecting
            item["parent"]       = item["tasks_parent"]
            item["tasks_parent"] = undefined

            taskEditScreen.setItem( item )
            pageStack.pageStack.push(taskEditScreen)
        }
    }

    TaskEditScreen {
        id: taskEditScreen
        visible: false

        onBackButtonClicked: pageStack.pageStack.pop()
    }



    SettingsManager {
        id: settingsManager
    }

    GoogleOAuth {
        id: google_oauth
        visible: false
        anchors.fill: parent
        z: 10
        onLoginDone: {
            visible = false;
            console.log("Login Done")
            settingsManager.accessToken = google_oauth.accessToken;
            TasksDataManager.getMyTaskLists()
        }
    }


    Component.onCompleted: {
        console.log("onCompleted!!")
        //google_oauth.accessToken = settingsManager.accessToken;
        if(settingsManager.refreshToken == "")
        {
            console.log("onCompleted")
            google_oauth.visible = true;
            google_oauth.login();
        }
        else
        {
            //BooksDataManager.getBookshelves();
            google_oauth.refreshAccessToken(settingsManager.refreshToken);
        }
    }

}
