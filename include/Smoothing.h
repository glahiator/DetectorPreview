#ifndef SMOOTHING_H
#define SMOOTHING_H

#include <QQuickPaintedItem>
#include <QString>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QImage>

#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/core/base.hpp>

class Smoothing : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString filename WRITE setFilename NOTIFY filenameChanged MEMBER filename)
public:
    Smoothing(QQuickItem *item = nullptr);
    void paint(QPainter * painter);

    QString filename;

    Q_INVOKABLE void boxFilterDraw(QSize s, QPoint p, bool isNorma, int borderType );
    Q_INVOKABLE void medianBlur(int apert_lin_size);
    Q_INVOKABLE void gaussianBlur(QSize s, double sigmaX, double sigmaY, int borderType);
    Q_INVOKABLE void bilateralFilter(int d, double sigmaColor, double sigmaSpace, int borderType );
    Q_INVOKABLE void resetImage( );

    void setFilename( QString _fn );

    QImage draw_img;
    cv::Mat src_frame;
    cv::Mat dst_frame;

signals:
    void filenameChanged( QString _fn );
};

#endif // SMOOTHING_H
