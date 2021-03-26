#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <QString>
#include <QStringList>

/*! \brief Path to the directory where the videos are stored.
*/
const QString VIDEOS_DIR("/home/desktop/videos/");

/*! \brief Path to the directory where the video thumbnails will be stored.
 *  If the directory does not exist the application will create it.
*/
const QString THUMBS_DIR("/home/desktop/videos/.thumbs/");

/*! \brief Path to the directory where the edited video thumbnails will be stored.
 *  If the directory does not exist the application will create it.
*/
const QString EDITED_VIDEOS_THUMBS_DIR("/home/desktop/videos/edited/.thumbs/");

/*! \brief Path to the directory where the edited videos will be stored.
 *  If the directory does not exist the application will create it.
*/
const QString EDITED_VIDEOS_DIR("/home/desktop/videos/edited/");

/*! \brief Allowed video formats for raw videos.
 *
*/
const QStringList VIDEO_FORMATS = {"*.mov","*.MOV",
                                  "*.avi","*.AVI",
                                  "*.mp4","*.MP4",
                                  "*.flv","*.FLV"};

#endif // CONSTANTS_H
