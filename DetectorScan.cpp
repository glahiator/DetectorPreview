#include "DetectorScan.h"

DetectorScan::DetectorScan(QQuickItem *item) : QQuickPaintedItem(item)
{
    filename = "";
}

void DetectorScan::paint(QPainter *painter)
{
    qDebug() << "In paint";
    painter->drawImage(QPoint(0,0), draw_img);
}

void DetectorScan::setFilename(QString _fn)
{
    if( _fn.isEmpty() ){
            return;
    } else if( _fn.contains("file:///") ){
        filename = _fn.remove(0,8);
    }
    // если необходимо, то добавить другие сценарии обработки
    // открытия файла в зависимости от файловой системы
    // и приведения filename к читаемому imread() виду

    OpenFileFromDisk();
}

QString DetectorScan::getFilename()
{
    return filename;
}

void DetectorScan::setThresh(int _th)
{
    qDebug() << "Set thresh";
    thresh = _th;
    DrawContours(thresh);
}

int DetectorScan::getThresh()
{
    return thresh;
}

void DetectorScan::OpenFileFromDisk()
{
    src_frame = cv::imread(filename.toStdString());
    if( src_frame.empty() ){
        qDebug() << filename << "error loading" ;
        return;
    }
    cv::cvtColor(src_frame, dst_frame, cv::COLOR_BGR2RGB);
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_RGB888 );
    this->update();
}

void DetectorScan::DrawContours(int _thresh)
{
    if( src_frame.empty() ){
        qDebug() << "empty src in DrawContours";
        return;
    }
    cv::Mat g_gray;
    cv::cvtColor(src_frame, g_gray, cv::COLOR_BGR2GRAY);

    cv::Mat g_binary;
    int g_thresh = _thresh;
    cv::threshold( g_gray, g_binary, g_thresh, 255, cv::THRESH_BINARY );
    std::vector< std::vector< cv::Point> > contours;
    cv::findContours(
                g_binary,
                contours,
                cv::noArray(),
                cv::RETR_LIST,
                cv::CHAIN_APPROX_SIMPLE
                );
    g_binary = cv::Scalar::all(0);
    cv::drawContours( g_binary, contours, -1, cv::Scalar::all(255));

    dst_frame = g_binary.clone();
    draw_img = QImage( dst_frame.data, dst_frame.cols, dst_frame.rows, QImage::Format_Grayscale8 );
    this->update();
}

