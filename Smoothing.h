#ifndef SMOOTHING_H
#define SMOOTHING_H

#include <QQuickPaintedItem>
#include <QString>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QImage>

#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>

class Smoothing : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString filename WRITE setFilename NOTIFY filenameChanged MEMBER filename)
public:
    Smoothing(QQuickItem *item = nullptr);
    void paint(QPainter * painter);

    QString filename;


    void setFilename( QString _fn );

    QImage draw_img;
    cv::Mat src_frame;
    cv::Mat dst_frame;

signals:
    void filenameChanged( QString _fn );
};

#endif // SMOOTHING_H
