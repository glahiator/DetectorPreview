#include "Threshold.h"

Threshold::Threshold(QQuickItem *item)  : QQuickPaintedItem(item)
{
    filename = "";
}

void Threshold::paint(QPainter *painter)
{
    painter->drawImage(QPoint(0,0), draw_img);
}

void Threshold::threshold(double _thresh, double _mv, int _type)
{
    std::vector< cv::Mat> planes;
    cv::split(src_frame, planes);
    cv::Mat b = planes[0], g = planes[1], r = planes[2], s;
    // Add equally weighted rgb values.
    //
    cv::addWeighted( r, 1./3., g, 1./3., 0.0, s );
    cv::addWeighted( s, 1., b, 1./3., 0.0, s );

    cv::threshold( s, dst_frame, _thresh, _mv, _type );

    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}

void Threshold::threshold_alt(double _thresh, double _mv, int _type)
{
    // Split image onto the color planes.
    //
    std::vector<cv::Mat> planes;
    cv::split(src_frame, planes);
    cv::Mat b = planes[0], g = planes[1], r = planes[2];
    // Accumulate separate planes, combine and threshold.
    //
    cv::Mat s = cv::Mat::zeros(b.size(), CV_32F);
    cv::accumulate(b, s);
    cv::accumulate(g, s);
    cv::accumulate(r, s);
    // Truncate values above 100 and rescale into dst.
    //
    cv::threshold( s, s, _thresh, _mv, _type );
    s.convertTo(dst_frame, b.type());

    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}

void Threshold::threshold_adapt( double _mv, int _adapt_meth, int _type, int _bs, double _const)
{
    qDebug() << _bs;
    cv::Mat gray_img;
    cv::cvtColor( src_frame, gray_img, cv::COLOR_BGR2GRAY );

    cv::adaptiveThreshold(
                gray_img,
                dst_frame,
                _mv,
                _adapt_meth,
                _type,
                _bs,
                _const
                );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_Grayscale8 );
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
