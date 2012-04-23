#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

#include "settings_manager.h"
#include "tasks_data_manager.h"
#include "DateTimeConverter.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    Q_INIT_RESOURCE(google_api_tasks_qml_resources);
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    qmlRegisterType<SettingsManager>(  "ICS", 1, 0, "SettingsManager");
    qmlRegisterType<TasksDataManager>( "ICS", 1, 0, "DeleteTasksDataManager");
    qmlRegisterType<DateTimeConverter>("ICS", 1, 0, "DateTimeConverter");

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setMainQmlFile(QLatin1String("qml/google_api_tasks_qml/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
