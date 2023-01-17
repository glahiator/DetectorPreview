#include "Drawing.h"

Drawing::Drawing(QQuickItem *item): QQuickPaintedItem(item)
{
    m_imgHeight = 0;
    m_imgWidth = 0;
}

void Drawing::preparePaint()
{
    cv::cvtColor( dst_frame, dst_frame, cv::COLOR_BGR2RGB );
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    m_imgHeight = draw_img.height();
    m_imgWidth = draw_img.width();
    emit imgHeightChanged();
    emit imgWidthChanged();
    this->update();
}
void Drawing::paint(QPainter *painter)
{
    painter->drawImage(QPoint(0,0), draw_img);
}
void Drawing::setFilename(QString _fn)
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
    emit srcImageSizeChanged(  );


}
void Drawing::resetImage()
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }

    src_frame.copyTo(dst_frame);
    preparePaint();
}

void Drawing::resize(int width, int height, int interType)
{
    if( src_frame.empty() ){
        qDebug() << "empty source" ;
        return;
    }

    cv::resize( src_frame,
                dst_frame,
                cv::Size(width,height),
                0,
                0,
                interType);

    preparePaint();
}

