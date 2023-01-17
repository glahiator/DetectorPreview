QT += quick qml

CONFIG += c++11

SOURCES += \
        src/DetectorScan.cpp \
        src/Drawing.cpp \
        src/Filter.cpp \
        src/Smoothing.cpp \
        src/Threshold.cpp \
        src/main.cpp

HEADERS += \
    include/DetectorScan.h \
    include/Drawing.h \
    include/Filter.h \
    include/Smoothing.h \
    include/Threshold.h

RESOURCES += res/qml.qrc


INCLUDEPATH += $$PWD/include/
INCLUDEPATH += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\include
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_core440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_highgui440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_imgcodecs440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_imgproc440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_objdetect440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_video440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_videoio440.dll
LIBS += C:\Users\glaha\Documents\Workspace\Libs\ownBuild\opencv-4.4.0\build\install\x64\mingw\bin\libopencv_videostab440.dll


