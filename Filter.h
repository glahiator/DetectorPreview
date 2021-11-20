#ifndef FILTER_H
#define FILTER_H

#include <QQuickPaintedItem>
#include <QString>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QImage>
#include <QMatrix4x4>

#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/core/base.hpp>

class Filter : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString filename WRITE setFilename NOTIFY filenameChanged MEMBER filename)

public:
    Filter(QQuickItem *item = nullptr);
    void paint(QPainter * painter);
    Q_INVOKABLE void resetImage( );
    Q_INVOKABLE void filter2DImage(QMatrix4x4 _m);

    void setFilename( QString _fn );

    QImage draw_img;
    cv::Mat src_frame;
    cv::Mat dst_frame;
    QString filename;

signals:
    void filenameChanged( QString _fn );
};

#endif // FILTER_H
