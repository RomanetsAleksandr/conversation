#include <QGuiApplication>
#include <QObject>
#include <QUrl>

#include <QtQml>

#include "dialogmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication application(argc, argv);

    // Объявляем и инициализируем модель диалога
    DialogModel* dialogModel = new DialogModel();

    // Обеспечиваем доступ к модели из QML
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("dialogModel", dialogModel);

    //Грузим Qml приложение
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    QObject::connect(&engine,SIGNAL(quit()),qApp,SLOT(quit()));

    return application.exec();
}
