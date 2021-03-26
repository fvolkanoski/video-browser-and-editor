#include "videoloadercontroller.h"

#include <QtAV/VideoFrameExtractor.h>

#include <QDir>
#include <QDebug>
#include <QQuickWindow>

#include "constants.h"

QString VideoLoaderController::getVideoThumbnail(QString videoFile, bool edited) {
    if(!edited)
        return "file://" + THUMBS_DIR + videoFile + ".jpg";
    else
        return "file://" + EDITED_VIDEOS_THUMBS_DIR + videoFile + ".jpg";
}

void VideoLoaderController::addNewEditedVideo(QString videoName) {
    generateThumbnail(EDITED_VIDEOS_DIR + videoName.split(".")[0] + ".avi",
                      EDITED_VIDEOS_THUMBS_DIR + videoName.split(".")[0] + ".avi" + ".jpg");

    QStringList newList = m_editedVideos;
    newList.push_back(EDITED_VIDEOS_DIR + videoName.split(".")[0] + ".avi");
    this->setEditedVideos(newList);
}

void VideoLoaderController::loadVideos() {
    QDir directory(VIDEOS_DIR);
    QStringList images = directory.entryList(VIDEO_FORMATS, QDir::Files);

    foreach(QString filename, images) {
        m_rawVideos.push_back(VIDEOS_DIR + filename);
        generateThumbnail(VIDEOS_DIR + filename, THUMBS_DIR + filename + ".jpg");
    }
}

void VideoLoaderController::loadEditedVideos()
{
    QDir directory(EDITED_VIDEOS_DIR);
    QStringList images = directory.entryList(VIDEO_FORMATS, QDir::Files);

    foreach(QString filename, images) {
        m_editedVideos.push_back(EDITED_VIDEOS_DIR + filename);
        generateThumbnail(EDITED_VIDEOS_DIR + filename, EDITED_VIDEOS_THUMBS_DIR + filename + ".jpg");
    }
}

bool VideoLoaderController::generateThumbnail(QString videoPath, QString thumbPath)
{
    if(!QFile::exists(thumbPath)) {
        auto extractor = new QtAV::VideoFrameExtractor;
        connect(
            extractor,
            &QtAV::VideoFrameExtractor::frameExtracted,
            extractor,
            [this, extractor, videoPath, thumbPath](const QtAV::VideoFrame& frame) {
                const auto& img = frame.toImage();
                img.save(thumbPath);
                extractor->deleteLater();
            });
        connect(
            extractor,
            &QtAV::VideoFrameExtractor::error,
            extractor,
            [this, extractor](const QString& errorStr) {
                qDebug() << errorStr;
                extractor->deleteLater();
            });

        extractor->setAsync(true);
        extractor->setSource(videoPath);
        extractor->setPosition(5);

        return true;
    }
    else
        return false;
}

void VideoLoaderController::setRawVideos(QStringList rawVideos) {
    if (m_rawVideos == rawVideos)
        return;

    m_rawVideos = rawVideos;
    emit rawVideosChanged(m_rawVideos);
}

void VideoLoaderController::setEditedVideos(QStringList editedVideos) {
    if (m_editedVideos == editedVideos)
        return;

    m_editedVideos = editedVideos;
    emit editedVideosChanged(m_editedVideos);
}

VideoLoaderController::VideoLoaderController(QObject *parent)
    : QObject(parent) {
    QDir thumbsDir;
    loadVideos();
    loadEditedVideos();

    if (!thumbsDir.exists(THUMBS_DIR)) thumbsDir.mkpath(THUMBS_DIR);
    if (!thumbsDir.exists(EDITED_VIDEOS_THUMBS_DIR)) thumbsDir.mkpath(EDITED_VIDEOS_THUMBS_DIR);
}
