#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    // To store application properties
    QGuiApplication::setApplicationName("2048");
    QCoreApplication::setOrganizationDomain("geckoblu.net");
    QGuiApplication::setOrganizationName("geckoblu");

    //QFont font( "Droid Sans" );
    //QGuiApplication::setFont( font );

    QGuiApplication app(argc, argv);

    app.setWindowIcon(QIcon(":./icon.png"));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
