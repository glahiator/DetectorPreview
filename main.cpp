#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "DetectorScan.h"
#include "Threshold.h"
#include "Smoothing.h"
#include "Filter.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    qmlRegisterType<DetectorScan>("DetectorScan", 1, 0, "DetectorScan");
    qmlRegisterType<Threshold>("opencv.Threshold", 1, 0, "ThresholdScan");
    qmlRegisterType<Smoothing>("opencv.Smoothing", 1, 0, "SmoothingScan");
    qmlRegisterType<Filter>( "opencv.Filter", 1, 0, "FilterScan" );
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/Filter.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
