/****************************************************************************
**
** The MIT License (MIT)
**
** Copyright (c) 2016 Filip Hazubski
**
** Permission is hereby granted, free of charge, to any person obtaining a
** copy of this software and associated documentation files (the "Software"),
** to deal in the Software without restriction, including without limitation
** the rights to use, copy, modify, merge, publish, distribute, sublicense,
** and/or sell copies of the Software, and to permit persons to whom the
** Software is furnished to do so, subject to the following conditions:
**
** The above copyright notice and this permission notice shall be included
** in all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
** OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
** OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
** THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**
****************************************************************************/

#include <QtQml>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QLocale>

#include "savedata.h"

#ifdef QT_DEBUG
#include <QDebug>
#endif

#ifdef Q_OS_ANDROID
#include "checkroot.h"
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QLocale locale;
    QString appLanguage = locale.uiLanguages()[0];
    appLanguage = appLanguage.left(2);

    bool debugMode;
    bool tablet7resolution = false;
    bool tablet10resolution = false;
#ifdef Q_OS_ANDROID
    CheckRoot checkRoot;
    bool deviceRooted = checkRoot.checkIfDeviceIsRooted();
    engine.rootContext()->setContextProperty("deviceIsRooted", deviceRooted);
#else
    engine.rootContext()->setContextProperty("deviceIsRooted", false);
#endif
#ifdef QT_DEBUG
    debugMode = true;
    tablet7resolution = false;
    tablet10resolution = false;
    appLanguage = "pl";
#else
    debugMode = false;
#endif

    engine.rootContext()->setContextProperty("debugMode", debugMode);
    engine.rootContext()->setContextProperty("tablet7resolution", tablet7resolution);
    engine.rootContext()->setContextProperty("tablet10resolution", tablet10resolution);
    engine.rootContext()->setContextProperty("defaultLanguage", appLanguage);

    qmlRegisterType<SaveData>("com.monkeybison.savedata", 1, 0, "SaveData");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
