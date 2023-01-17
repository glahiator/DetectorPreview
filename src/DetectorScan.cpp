#include "DetectorScan.h"

DetectorScan::DetectorScan(QQuickItem *item) : QQuickPaintedItem(item)
{
    firstFile = "";
    secondFile = "";
}

void DetectorScan::paint(QPainter *painter)
{
    qDebug() << "In paint";
    painter->drawImage(QPoint(0,0), draw_img);
    painter->drawImage(QPoint(0, draw_img.height()), draw_img2);
    painter->drawImage(QPoint(0, draw_img.height()*2), draw_img3);

}

void DetectorScan::setFirstFilename(QString _fn)
{
    if( _fn.isEmpty() ){
            return;
    } else if( _fn.contains("file:///") ){
        firstFile = _fn.remove(0,8);
    }
    // если необходимо, то добавить другие сценарии обработки
    // открытия файла в зависимости от файловой системы
    // и приведения filename к читаемому imread() виду

    OpenFileFromDisk(1);
}

void DetectorScan::setSecondFilename(QString _fn)
{
    if( _fn.isEmpty() ){
            return;
    } else if( _fn.contains("file:///") ){
        secondFile = _fn.remove(0,8);
    }
    OpenFileFromDisk(2);
}

void DetectorScan::OpenFileFromDisk(int8_t ident)
{
    if( 1 == ident ){
        imgA = cv::imread(firstFile.toStdString(), cv::IMREAD_GRAYSCALE);
        img_sz = imgA.size();
        if( imgA.empty() ){
            qDebug() << firstFile << "error loading" ;
            return;
        }
    }

    else if( 2 == ident ){
        imgB = cv::imread(secondFile.toStdString(), cv::IMREAD_GRAYSCALE);
        imgC = cv::imread(secondFile.toStdString());
        if( imgB.empty() || imgC.empty()){
            qDebug() << secondFile << "error loading" ;
            return;
        }
    }
}

void DetectorScan::pyramidLK()
{

    int win_size = 10;
    std::vector< cv::Point2f > cornersA, cornersB;
    const int MAX_CORNERS = 500;
    cv::goodFeaturesToTrack(
                imgA,                         // Image to track
                cornersA,                     // Vector of detected corners (output)
                MAX_CORNERS,                  // Keep up to this many corners
                0.01,                         // Quality level (percent of maximum)
                5,                            // Min distance between corners
                cv::noArray(),                // Mask
                3,                            // Block size
                false,                        // true: Harris, false: Shi-Tomasi
                0.04                          // method specific parameter
                );

    cv::cornerSubPix(
                imgA,                         // Input image
                cornersA,                     // Vector of corners (input and output)
                cv::Size(win_size, win_size), // Half side length of search window
                cv::Size(-1,-1),              // Half side length of dead zone (-1=none)
                cv::TermCriteria(
                    cv::TermCriteria::COUNT | cv::TermCriteria::EPS,
                    20,                         // Maximum number of iterations
                    0.03                        // Minimum change per iteration
                    )
                );

    // Call the Lucas Kanade algorithm
    //
    std::vector<uchar> features_found;
    cv::calcOpticalFlowPyrLK(
                imgA,                         // Previous image
                imgB,                         // Next image
                cornersA,                     // Previous set of corners (from imgA)
                cornersB,                     // Next set of corners (from imgB)
                features_found,               // Output vector, each is 1 for tracked
                cv::noArray(),                // Output vector, lists errors (optional)
                cv::Size( win_size*2+1, win_size*2+1 ), // Search window size
                5,                            // Maximum pyramid level to construct
                cv::TermCriteria(
                    cv::TermCriteria::MAX_ITER | cv::TermCriteria::EPS,
                    20,                         // Maximum number of iterations
                    0.3                         // Minimum change per iteration
                    )
                );

    // Now make some image of what we are looking at:
    // Note that if you want to track cornersB further, i.e.
    // pass them as input to the next calcOpticalFlowPyrLK,
    // you would need to "compress" the vector, i.e., exclude points for which
    // features_found[i] == false.
    for( int i = 0; i < (int)cornersA.size(); i++ ) {
        if( !features_found[i] )
            continue;
        line(
                    imgC,                        // Draw onto this image
                    cornersA[i],                 // Starting here
                    cornersB[i],                 // Ending here
                    cv::Scalar(0,255,0),         // This color
                    2,                           // This many pixels wide
                    cv::LINE_AA                  // Draw line in this style
                    );
    }

    draw_img  = QImage( imgA.data, imgA.cols, imgA.rows, QImage::Format_Grayscale8 );
    draw_img2 = QImage( imgB.data, imgB.cols, imgB.rows, QImage::Format_Grayscale8 );
    draw_img3 = QImage( imgC.data, imgC.cols, imgC.rows, QImage::Format_RGB888 );
    this->update();

}
