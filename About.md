# Introduction #

Information about use Google API, testing platforms, Qt versions.

# Details #

Project **qml-google-tasks** uses Google Tasks API. Project contains 2 subprojects - version for **meego** and version for **symbian**.

### Google API ###

Project **qml-google-tasks** uses Google Tasks API.

How it works:
Work with Google-API perfomed by send XMLHttpRequest (see file _tasks\_data\_manager.js_)

API features used in this project:
|get tasks lists|
|:--------------|
|create list|
|delete list|
|update list|
|clear tasks from list|
|get tasks by list|
|create task|
|delete task|
|update task|
|move task in list (up, down, left, right)|


File **[HowToRegisterYourAppIicationInGoogle](http://code.google.com/p/qml-google-tasks/wiki/HowToRegisterYourApplicationInGoogle)** describes how register your own application on Google.

### Tested platforms ###
Both subproject were tested on:
| **OS** | **Qt version** |
|:-------|:---------------|
|Arch Linux 64bit in simulator|Qt 4.7.4 (QtSDK 1.2.1)|
|Windows 7 64bit/32bit in simulator|Qt 4.7.4 (QtSDK 1.2.1)|

**Symbian** subproject was tested on:
| **Phone (OS)** | **Qt version** |
|:---------------|:---------------|
|Nokia C7 (Symbian 3)|4.7.4|

You can download package for symbian from [Downloads](http://code.google.com/p/qml-google-tasks/downloads/list) tab ([qml-google-tasks-symbian.sis](http://qml-google-tasks.googlecode.com/files/qml-google-tasks-symbian.sis)).

**MeeGo** subproject was tested on:
| **Phone** | **Qt version** |
|:----------|:---------------|
|Nokia N9|4.8.0|


# Various comments #
1. **Caution!** In version for symbian maybe you need replace string
**import com.nokia.symbian 1.0** to string **import com.nokia.symbian 1.1** (or backwards) in qml-files depending on version QtSDK.

2. **Caution!** In version for meego maybe you need replace string
**import com.nokia.meego 1.0** to string **import com.nokia.meego 1.1** (or backwards) in qml-files depending on version QtSDK.

3. **Caution!** In version for symbian and meego maybe you need replace string **import com.nokia.extras 1.0** to string **import com.nokia.extras 1.1** (or backwards) in qml-files depending on version QtSDK.

4. You need to install Qt and qt-components on your phone.

# Screenshots #
![http://qml-google-tasks.googlecode.com/files/qml-tasks-2.jpg](http://qml-google-tasks.googlecode.com/files/qml-tasks-2.jpg) ![http://qml-google-tasks.googlecode.com/files/qml-tasks-3.jpg](http://qml-google-tasks.googlecode.com/files/qml-tasks-3.jpg) ![http://qml-google-tasks.googlecode.com/files/qml-tasks-4.jpg](http://qml-google-tasks.googlecode.com/files/qml-tasks-4.jpg)