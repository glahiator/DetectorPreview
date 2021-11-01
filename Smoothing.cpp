#include "Smoothing.h"

Smoothing::Smoothing(QQuickItem *item)  : QQuickPaintedItem(item)
{

}

void Smoothing::paint(QPainter *painter)
{
    painter->drawImage(QPoint(0,0), draw_img);
}

void Smoothing::boxFilterDraw(QSize s, QPoint p, bool isNorma, int borderType)
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }
    cv::Size kernel_size ( s.width(), s.height() );
    cv::Point anchor (p.x(), p.y());
    bool normalize = isNorma;

    cv::boxFilter(
                src_frame, // Input image
                dst_frame, // Result image
                src_frame.depth(), // Output depth (e.g., CV_8U)
                kernel_size, // Kernel size
                anchor, // Location of anchor point
                normalize, // If true, divide by box area
                borderType // Border extrapolation to use
                );


    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}
void Smoothing::medianBlur(int apert_lin_size)
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }

    cv::medianBlur(
                src_frame, // Input image
                dst_frame, // Result image
                apert_lin_size
                );
    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}
void Smoothing::gaussianBlur(QSize s, double sigmaX, double sigmaY, int borderType)
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }

    cv::GaussianBlur(
                src_frame, // Input image
                dst_frame, // Result image
                cv::Size( s.width(), s.height() ), // Kernel size
                sigmaX, // Gaussian half-width in x-direction
                sigmaY , // Gaussian half-width in y-direction
                borderType  // Border extrapolation to use
            );

    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}
void Smoothing::bilateralFilter(int d, double sigmaColor, double sigmaSpace, int borderType)
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }

    qDebug() << d << sigmaColor << sigmaSpace;

    cv::bilateralFilter(
                src_frame, // Input image
                dst_frame, // Result image
                d,        // Pixel neighborhood size (max distance)
                sigmaColor, // Width param for color weight function
                sigmaSpace, // Width param for spatial weight function
                borderType  // Border extrapolation to use
            );
    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}

void Smoothing::resetImage()
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }
    cv::cvtColor( src_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
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


    qDebug() << "IMAGE PREF" << src_frame.type() << src_frame.depth() << src_frame.rows << src_frame.cols;

    if( src_frame.empty() ){
        qDebug() << filename << "error loading" ;
        return;
    }

    cv::cvtColor( src_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}
