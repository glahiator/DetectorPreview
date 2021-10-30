#include "Smoothing.h"

Smoothing::Smoothing(QQuickItem *item)  : QQuickPaintedItem(item)
{

}

void Smoothing::paint(QPainter *painter)
{
    painter->drawImage(QPoint(0,0), draw_img);
}


void Smoothing::setFilename(QString _fn)
{
    if( _fn.isEmpty() ){
            return;
    } else if( _fn.contains("file:///") ){
        filename = _fn.remove(0,8);
    }

    emit filenameChanged(filename);

    src_frame = cv::imread(filename.toStdString());

    if( src_frame.empty() ){
        qDebug() << filename << "error loading" ;
        return;
    }

    cv::cvtColor( src_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}
