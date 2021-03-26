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
    QString extract = "ffmpeg -i " + VIDEOS_DIR + videoName + " -f mp3 -ab 192000 -vn " + EDITED_VIDEOS_DIR + videoName + ".mp3",
            import = "ffmpeg -i " + EDITED_VIDEOS_DIR + videoName.split(".")[0] + ".avi" + " -i " + EDITED_VIDEOS_DIR + videoName + ".mp3" + " -c copy -map 0:v:0 -map 1:a:0 " + EDITED_VIDEOS_DIR + "new_" + videoName.split(".")[0] + ".avi",
            remove_old_video = "rm " + EDITED_VIDEOS_DIR + videoName.split(".")[0] + ".avi",
            remove_sound_file = "rm " + EDITED_VIDEOS_DIR + videoName + ".mp3",
            add_new = "mv " + EDITED_VIDEOS_DIR + "new_" + videoName.split(".")[0] + ".avi" + " " + EDITED_VIDEOS_DIR + videoName.split(".")[0] + ".avi",
            remove_script = "rm " + VIDEOS_DIR + videoName + ".sh";


    QFile file(VIDEOS_DIR + videoName + ".sh");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);
    out << extract << "\n"
        << import << "\n"
        << remove_old_video << "\n"
        << add_new << "\n"
        << remove_sound_file << "\n"
        << remove_script;

    file.close();
}
