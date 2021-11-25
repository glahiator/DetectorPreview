QT += quick qml

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        DetectorScan.cpp \
        Drawing.cpp \
        Filter.cpp \
        Smoothing.cpp \
        Threshold.cpp \
        main.cpp

RESOURCES += qml.qrc


INCLUDEPATH += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\include
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_core440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_highgui440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_imgcodecs440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_imgproc440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_objdetect440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_video440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_videoio440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_videostab440.dll

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    DetectorScan.h \
    Drawing.h \
    Filter.h \
    Smoothing.h \
    Threshold.h
