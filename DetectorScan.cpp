#include "DetectorScan.h"

DetectorScan::DetectorScan(QQuickItem *item) : QQuickPaintedItem(item)
{
    filename = "";
}

void DetectorScan::paint(QPainter *painter)
{
    qDebug() << "In paint";
//    QRectF target(0.0, 0.0,  80.0, 60.0);
//    QRectF source(0.0, 0.0, 70.0, 40.0);

    QRectF rect;
    rect.setSize(dst_img.size());


    painter->drawImage(QPoint(0,0), dst_img);

}

void DetectorScan::setFilename(QString _fn)
{
    qDebug() << _fn.remove(0,8);
    filename = _fn;

    dst_img.load(filename);
    this->update();
//    src_frame = cv::imread(filename.toStdString());
//    if( src_frame.empty() ){
//        qDebug() << "error loading";
//        return;
//    }
//    dst_frame = src_frame.clone();

//    cv::cvtColor(src_frame, dst_frame, cv::COLOR_BGR2RGB);

//    src_img = QImage( QSize( src_frame.cols, src_frame.rows ), QImage::Format_RGB888 );
//    dst_img = QImage( QSize( dst_frame.cols, dst_frame.rows ), QImage::Format_RGB888 );



//    QImage image(":/images/myImage.png");


}

QString DetectorScan::getFilename()
{
    return filename;
}
