#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "videoloadercontroller.h"
#include "videoeditorcontroller.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    VideoLoaderController *videoLoaderController = new VideoLoaderController();
    VideoEditorController *videoEditorController = new VideoEditorController();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("videoLoader", videoLoaderController);
    engine.rootContext()->setContextProperty("videoEditor", videoEditorController);
    engine.rootContext()->setContextProperty("rawVideos", videoLoaderController->rawVideos());
    engine.rootContext()->setContextProperty("editedVideos", videoLoaderController->editedVideos());

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
