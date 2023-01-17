QT += quick qml

CONFIG += c++11

SOURCES += \
        DetectorScan.cpp \
        Drawing.cpp \
        Filter.cpp \
        Smoothing.cpp \
        Threshold.cpp \
        main.cpp

HEADERS += \
    DetectorScan.h \
    Drawing.h \
    Filter.h \
    Smoothing.h \
    Threshold.h

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


