#ifndef VIDEOLOADERCONTROLLER_H
#define VIDEOLOADERCONTROLLER_H

#include <QObject>

/*! \brief The VideoLoaderController class.
 *  This class is exposed to the QML and controls the loading raw
 *  and edited videos, checking directories and creating thumbnails.
*/
class VideoLoaderController : public QObject {
    Q_OBJECT

    Q_PROPERTY(QStringList rawVideos READ rawVideos WRITE setRawVideos NOTIFY rawVideosChanged)
    Q_PROPERTY(QStringList editedVideos READ editedVideos WRITE setEditedVideos NOTIFY editedVideosChanged)

public:
    /*! \brief The default constructor for the VideoLoaderController class.
    */
    explicit VideoLoaderController(QObject *parent = nullptr);

    /*! \brief Invokable function, returns the path of the thumbnail for a video.
     *  @param[in] videoFile The video file for which we are requesting thumbnail.
     *  @param[in] edited Whether we are requesting thumbnail for a edited video or not.
    */
    Q_INVOKABLE QString getVideoThumbnail(QString videoFile, bool edited);

    /*! \brief Invokable function, adds a new edited video in the editedVideos list.
     *  @param[in] videoName The name of the new edited video.
    */
    Q_INVOKABLE void addNewEditedVideo(QString videoName);

    /*! \brief Loads the videos from the directory into the app.
    */
    void loadVideos();

    /*! \brief Loads the edited videos from the directory into the app.
    */
    void loadEditedVideos();

    /*! \brief Generates a thumbnail for the requested video.
     *  @param[in] videoPath The path to the video for which we are requesting thumbnail.
     *  @param[in] videoPath The path where we want the thumbnail to be created in.
    */
    bool generateThumbnail(QString videoPath, QString thumbPath);

    /*! \brief Getter for the rawVideos variable.
    */
    QStringList rawVideos() const {
        return m_rawVideos;
    }

    /*! \brief Getter for the editedVideos variable.
    */
    QStringList editedVideos() const {
        return m_editedVideos;
    }

public slots:
    /*! \brief Setter for the rawVideos variable.
    */
    void setRawVideos(QStringList rawVideos);

    /*! \brief Setter for the editedVideos variable.
    */
    void setEditedVideos(QStringList editedVideos);

signals:
    /*! \brief Notify signal for the rawVideos variable.
     *  It gets emitted when setRawVideos is called.
    */
    void rawVideosChanged(QStringList rawVideos);

    /*! \brief Notify signal for the editedVideos variable.
     *  It gets emitted when setEditedVideos is called.
    */
    void editedVideosChanged(QStringList editedVideos);

private:
    QStringList m_rawVideos;
    QStringList m_editedVideos;
};

#endif // VIDEOLOADERCONTROLLER_H
