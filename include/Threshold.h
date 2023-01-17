#ifndef THRESHOLD_H
#define THRESHOLD_H

#include <QObject>
#include <QString>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QImage>

#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>

class Threshold : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString filename  WRITE setFilename  MEMBER filename)
public:
    Threshold(QQuickItem *item = nullptr);
    void paint(QPainter * painter);

    Q_INVOKABLE void threshold(double _thresh, double _mv, int _type);
    Q_INVOKABLE void threshold_alt(double _thresh, double _mv, int _type);
    Q_INVOKABLE void threshold_adapt(double _mv, int _adapt_meth, int _type, int _bs, double _const);

private:
    QString filename;
    void    setFilename( QString _fn );
    QImage draw_img;
    cv::Mat src_frame;
    cv::Mat dst_frame;
};

#endif // THRESHOLD_H
