TEMPLATE = app

QT += qml quick
android {
    QT += androidextras
    SOURCES += checkroot.cpp
    HEADERS += checkroot.h
}
CONFIG += c++11 resources_big

SOURCES += main.cpp \
    savedata.cpp

HEADERS += \
    savedata.h

RESOURCES += qml.qrc \
    assets.qrc \
    translations.qrc \
    qml_games.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/com/monkeybison/newgameeveryweek/CheckRoot.java

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
