#include "videoeditorcontroller.h"

#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgcodecs.hpp>

#include <QDir>
#include <QDateTime>
#include <QImage>
#include <QProcess>

#include "constants.h"

VideoEditorController::VideoEditorController(QObject *parent)
    : QObject(parent) {
    QDir editedVideosDir;
    isRecording = false;

    if (!editedVideosDir.exists(EDITED_VIDEOS_DIR)) {
        editedVideosDir.mkpath(EDITED_VIDEOS_DIR);
    }
}

bool VideoEditorController::record(QQuickWindow *rootWindow, QString videoName) {

    QImage image = rootWindow->grabWindow().convertToFormat(QImage::Format_RGB888);
    cv::Mat mat(image.height(), image.width(), CV_8UC3, image.bits());

    cv::cvtColor (mat, mat, cv::COLOR_RGB2BGR);

    if (!isRecording)
    {
        QString filePathName = EDITED_VIDEOS_DIR + videoName.split(".")[0] + ".avi";
        writer.open(filePathName.toStdString(), cv::VideoWriter::fourcc('M','J','P','G'), 20, cv::Size(image.width(), image.height()), true);
        isRecording = true;
    }

    if (writer.isOpened())
    {
        writer.write(mat);
    }

    return true;
}

void VideoEditorController::endRecord() {
    isRecording = false;
    writer.release();
}

void VideoEditorController::extractVideoSound(QString videoName)
{
//    QProcess process;
//    process.start("ffmpeg -i " + QDir::toNativeSeparators("/home/desktop/videos/sample.mp4") + " -f mp3 -ab 192000 -vn " + QDir::toNativeSeparators("/home/desktop/videos/edited/bunny.mp3"));
//    qDebug() << process.isOpen();
//    process.waitForFinished();
//    qDebug() << process.readAll();
}
