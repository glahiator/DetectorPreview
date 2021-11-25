#include "Filter.h"


Filter::Filter(QQuickItem *item) : QQuickPaintedItem(item)
{

}

void Filter::preparePaint()
{
    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    m_imgHeight = draw_img.height();
    m_imgWidth = draw_img.width();
    emit imgHeightChanged();
    emit imgWidthChanged();
    this->update();
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

    src_frame.copyTo(dst_frame);
    preparePaint();
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

    preparePaint();
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

    preparePaint();
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
    preparePaint();
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

    preparePaint();
}
void Filter::morphologyEx(int op, int iterations, int shape, int _ks)
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }
    cv::Size ksize = cv::Size(_ks, _ks);
    cv::InputArray 	kernel =  cv::getStructuringElement	(shape,
                                                         ksize,
                                                         cv::Point(-1,-1)
                                                         );

    cv::morphologyEx(src_frame,
                     dst_frame,
                     op,
                     kernel,
                     cv::Point(-1,-1),
                     iterations,
                     cv::BORDER_CONSTANT
    );

    preparePaint();
}
void Filter::applyColorMap(int colorMap)
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }

    cv::applyColorMap( src_frame,
                       dst_frame,
                       colorMap);
    preparePaint();
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

    if( src_frame.empty() ){
        qDebug() << filename << "error loading" ;
        return;
    }

    resetImage();
}
