#include "Threshold.h"

Threshold::Threshold(QQuickItem *item)
{
    filename = "";
}

void Threshold::paint(QPainter *painter)
{
    qDebug() << "In paint";
    painter->drawImage(QPoint(0,0), draw_img);
}

void Threshold::threshold(double _thresh, double _mv, int _type)
{
    qDebug() << _type;
    std::vector< cv::Mat> planes;
    cv::split(src_frame, planes);
    cv::Mat b = planes[0], g = planes[1], r = planes[2], s;
    // Add equally weighted rgb values.
    //
    cv::addWeighted( r, 1./3., g, 1./3., 0.0, s );
    cv::addWeighted( s, 1., b, 1./3., 0.0, s );

    cv::threshold( s, dst_frame, _thresh, _mv, cv::THRESH_TRUNC );

    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();


}

void Threshold::setFilename(QString _fn)
{
    if( _fn.isEmpty() ){
            return;
    } else if( _fn.contains("file:///") ){
        filename = _fn.remove(0,8);
    }

    src_frame = cv::imread(filename.toStdString());

    if( src_frame.empty() ){
        qDebug() << filename << "error loading" ;
        return;
    }

    cv::cvtColor( src_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}
