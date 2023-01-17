#ifndef DRAWING_H
#define DRAWING_H

#include <QQuickPaintedItem>
#include <QString>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QImage>
#include <QMatrix4x4>

#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/core/base.hpp>

class Drawing : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString filename WRITE setFilename NOTIFY filenameChanged MEMBER filename)
    Q_PROPERTY(int imgHeight  NOTIFY imgHeightChanged MEMBER m_imgHeight)
    Q_PROPERTY(int imgWidth  NOTIFY imgHeightChanged MEMBER m_imgWidth)

public:
    Drawing(QQuickItem *item = nullptr);
    void preparePaint();
    void paint(QPainter * painter);
    void setFilename( QString _fn );

    Q_INVOKABLE void resetImage( );
    Q_INVOKABLE void resize(int width, int height, int interType);

signals:
    void filenameChanged( QString _fn );
    void imgHeightChanged();
    void imgWidthChanged();
    void srcImageSizeChanged( );

private:
    QImage draw_img;
    cv::Mat src_frame;
    cv::Mat dst_frame;
    QString filename;

    int m_imgHeight;
    int m_imgWidth;

};

#endif // DRAWING_H
