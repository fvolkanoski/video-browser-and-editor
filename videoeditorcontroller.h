#ifndef VIDEOEDITORCONTROLLER_H
#define VIDEOEDITORCONTROLLER_H

#include <QObject>
#include <QQuickWindow>

#include <opencv2/videoio.hpp>

/*! \brief The VideoEditorController class.
 *  This class is exposed to the QML and controls the renreding process
 *  of videos.
*/
class VideoEditorController : public QObject {
    Q_OBJECT

public:
    /*! \brief The default constructor for the VideoEditorController.
    */
    explicit VideoEditorController(QObject *parent = nullptr);

    /*! \brief Invokable function, stars the rendering of the edited video.
     *  @param[in] rootWindow The window which will be recorded.
     *  @param[in] videoName Name of the video which is being edited.
    */
    Q_INVOKABLE bool record(QQuickWindow *rootWindow, QString videoName);

    /*! \brief Invokable function, ends the rendering of the edited video.
    */
    Q_INVOKABLE void endRecord();

    /*! \brief Invokable function, extracts the sound from the original video
     *         and inserts it into the edited video.
     *  @param[in] videoName Name of the video which is being edited.
    */
    Q_INVOKABLE void extractVideoSound(QString videoName);

private:
    cv::VideoWriter writer;
    bool isRecording;
};

#endif // VIDEOEDITORCONTROLLER_H
