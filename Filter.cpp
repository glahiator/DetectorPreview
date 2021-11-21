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
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }

    cv::Matx33f f2dkernel( _m(0,0), _m(0,1), _m(0,2),
                           _m(1,0), _m(1,1), _m(1,2),
                           _m(2,0), _m(2,1), _m(2,2));
    int depth = -1; // output depth same as source
    filter2D(src_frame,dst_frame,depth,f2dkernel);

    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();


}

void Filter::sobelDeriv( int xorder, int yorder, int ksize, double scale, double delta )
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }

    int ddepth = -1;

    cv::Sobel( src_frame, // Input image
               dst_frame, // Result image
               ddepth, // Pixel depth of output (e.g., CV_8U)
               xorder, // order of corresponding derivative in x
               yorder, // order of corresponding derivative in y
               ksize, // Kernel size
               scale, // Scale (applied before assignment)
               delta, // Offset (applied before assignment)
               cv::BORDER_DEFAULT // Border extrapolation
    );

    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}

void Filter::scharrDeriv(int xorder, int yorder, double scale, double delta)
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }

    int ddepth = -1;

    cv::Scharr( src_frame, // Input image
                dst_frame, // Result image
                ddepth, // Pixel depth of output (e.g., CV_8U)
                xorder, // order of corresponding derivative in x
                yorder, // order of corresponding derivative in y
                scale, // Scale (applied before assignment)
                delta, // Offset (applied before assignment)
                cv::BORDER_DEFAULT // Border extrapolation
                );
    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}

void Filter::laplacianDeriv(int ksize, double scale, double delta)
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }

    int ddepth = -1;

    cv::Laplacian(src_frame, // Input image
                  dst_frame, // Result image
                  ddepth, // Pixel depth of output (e.g., CV_8U)
                  ksize, // Kernel size
                  scale, // Scale (applied before assignment)
                  delta, // Offset (applied before assignment)
                  cv::BORDER_DEFAULT // Border extrapolation
                  );

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
