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
    Q_PROPERTY(QString firstFile  WRITE setFirstFilename  MEMBER firstFile)
    Q_PROPERTY(QString secondFile WRITE setSecondFilename MEMBER secondFile)

public:
    DetectorScan(QQuickItem *item = nullptr);
    void paint(QPainter * painter);

    Q_INVOKABLE void pyramidLK();

private:
    QString firstFile;
    QString secondFile;
    void    setFirstFilename( QString _fn );
    void    setSecondFilename( QString _fn );

    void OpenFileFromDisk(int8_t ident); // openFile from disk to src_frame

    QImage draw_img;
    QImage draw_img2;
    QImage draw_img3;



    cv::Mat imgA;
    cv::Mat imgB;
    cv::Size img_sz;
    cv::Mat imgC;

    cv::Mat src_frame;
    cv::Mat dst_frame; // все изменения проводимые в OpenCV проводятся с данным объектом

signals:



};

#endif // DETECTORSCAN_H
