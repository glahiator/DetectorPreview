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
    Q_PROPERTY(QString filepath WRITE setFilename READ getFilename)

public:
    DetectorScan(QQuickItem *item = nullptr);
    void paint(QPainter * painter);


private:
    QString filename;

    void    setFilename( QString _fn );
    QString getFilename() ;

    QImage src_img;
    QImage dst_img;
    cv::Mat src_frame;
    cv::Mat dst_frame;


signals:



};

#endif // DETECTORSCAN_H
