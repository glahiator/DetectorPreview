#ifndef DETECTORSCAN_H
#define DETECTORSCAN_H

#include <QObject>
#include <QString>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QImage>

#include <opencv2/opencv.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

class DetectorScan : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString filename WRITE setFilename READ getFilename)
    Q_PROPERTY(int thresh READ getThresh WRITE setThresh )

public:
    DetectorScan(QQuickItem *item = nullptr);
    void paint(QPainter * painter);


private:
    QString filename;

    void    setFilename( QString _fn );
    QString getFilename() ;

    int thresh;
    void setThresh( int _th );
    int  getThresh();

    void OpenFileFromDisk(); // openFile from disk to src_frame

//    OpenCV methods for image processing
    void DrawContours( int _thresh );

    QImage draw_img;
    cv::Mat src_frame;
    cv::Mat dst_frame; // все изменения проводимые в OpenCV проводятся с данным объектом

signals:



};

#endif // DETECTORSCAN_H
