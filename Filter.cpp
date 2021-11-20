#include "Filter.h"


Filter::Filter(QQuickItem *item) : QQuickPaintedItem(item)
{

}

void Filter::paint(QPainter *painter)
{
    painter->drawImage(QPoint(0,0), draw_img);
}

void Filter::resetImage()
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }
    cv::cvtColor( src_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}

void Filter::filter2DImage( QMatrix4x4 _m )
{

    qDebug() << _m(0,0) << _m(0,1) <<  _m(0,2);
    cv::Matx33f f2dkernel( _m(0,0), _m(0,1), _m(0,2),
                           _m(1,0), _m(1,1), _m(1,2),
                           _m(2,0), _m(2,1), _m(2,2));
    int depth = -1; // output depth same as source
    filter2D(src_frame,dst_frame,depth,f2dkernel);

    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();


}

void Filter::setFilename(QString _fn)
{
    if( _fn.isEmpty() ){
            return;
    } else if( _fn.contains("file:///") ){
        filename = _fn.remove(0,8);
    }

    emit filenameChanged(filename);

    src_frame = cv::imread(filename.toStdString());


    qDebug() << "IMAGE PREF" << src_frame.channels() << src_frame.type() << src_frame.depth() << src_frame.rows << src_frame.cols;

    if( src_frame.empty() ){
        qDebug() << filename << "error loading" ;
        return;
    }

    cv::cvtColor( src_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}
