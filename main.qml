import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtAV 1.6

import "MainMenu"
import "VideoMenu"
import "EditVideos"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Video Browser")

    Video {
        id: videoPlayer
        anchors.fill: parent
        visible: false
        z: 1

        // We can't use internal playing() and paused(), they are not
        // implemented properly and don' work as they should.
        property bool isPlaying: false;

        onStopped: {
            videoPlayer.source = ""
            changeMenu(9)
        }

        Text {
            id: pausedText
            anchors.centerIn: parent
            text: "Paused"
            color: "white"
            font.pixelSize: 20
            visible: false
        }

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height - 50

            Rectangle {
                color: "white"
                width: 30
                height: 30
                border.color: "red"
                border.width: 2
                radius: 160


                Rectangle {
                    color: "red"
                    anchors.centerIn: parent
                    width: parent.width / 3
                    height: parent.height / 3
                    radius: 3
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        videoPlayer.play()
                        videoPlayer.stop()
                        videoPlayer.source = ""
                        videoPlayer.isPlaying = false
                        changeMenu(9)
                    }
                }
            }

            Rectangle {
                color: "white"
                width: 30
                height: 30
                border.color: "red"
                border.width: 2
                radius: 160

                Text {
                    id: pauseButtonText
                    text: "I I"
                    color: "red"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if(videoPlayer.isPlaying)
                        {
                            videoPlayer.pause()
                            pausedText.visible = true
                            pauseButtonText.text = "Play"
                            pauseButtonText.font.pixelSize = 10
                            videoPlayer.isPlaying = false
                        }
                        else
                        {
                            videoPlayer.play()
                            pausedText.visible = false
                            pauseButtonText.text = "I I"
                            pauseButtonText.font.pixelSize = 15
                            videoPlayer.isPlaying = true
                        }
                    }
                }
            }
        }
    }

    SwipeView {
        id: mainMenu
        anchors.fill: parent

        MainMenuItem {
            itemDisplayName: "Raw Videos"

            onItemClicked: {
                changeMenu(1)
            }
        }

        MainMenuItem {
            itemDisplayName: "Edited Videos"

            onItemClicked: {
                changeMenu(2)
            }
        }
    }

    SwipeView {
        id: rawVideosMenu
        anchors.fill: parent
        visible: false

        Repeater {
            model: rawVideos

            VideoMenuItem {
                editable: true
                thumbnail: ""
                name: modelData.split('\\').pop().split('/').pop();

                onItemClicked: {
                    videoPlayer.source = "file://" + modelData
                    changeMenu(9)
                    videoPlayer.play()
                    videoPlayer.isPlaying = true
                }

                onEditItem: {
                    editWindow.videoName = modelData.split('\\').pop().split('/').pop();
                    editWindow.videoPath = "file://" + modelData
                    editWindow.videoThumbPath = videoLoader.getVideoThumbnail(modelData.split('\\').pop().split('/').pop(), false);
                    editWindow.visible = true

                    videoEditor.extractVideoSound("videoName");
                }

                // Wait in case thumbnails are still generated.
                Timer {
                    interval: 200
                    repeat: false
                    running: true

                    onTriggered: {
                        parent.thumbnail = videoLoader.getVideoThumbnail(modelData.split('\\').pop().split('/').pop(), false);
                    }
                }
            }
        }

        VideoMenuItem {
            thumbnail: "qrc:/res/return.png"
            name: "Main Menu"

            onItemClicked: {
                changeMenu(1)
            }
        }

        Component.onCompleted: {
            currentIndex = 0
        }
    }

    SwipeView {
        id: editedVideosMenu
        anchors.fill: parent
        visible: false

        Repeater {
            id: editedRptr
            model: videoLoader.editedVideos

            VideoMenuItem {
                editable: false
                thumbnail: ""
                name: modelData.split('\\').pop().split('/').pop();

                onItemClicked: {
                    videoPlayer.source = "file://" + modelData
                    changeMenu(9)
                    videoPlayer.play()
                    videoPlayer.isPlaying = true
                }

                // Wait in case thumbnails are still generated.
                Timer {
                    interval: 200
                    repeat: false
                    running: true

                    onTriggered: {
                        parent.thumbnail = videoLoader.getVideoThumbnail(modelData.split('\\').pop().split('/').pop(), true);
                    }
                }
            }
        }

        VideoMenuItem {
            thumbnail: "qrc:/res/return.png"
            name: "Main Menu"

            onItemClicked: {
                changeMenu(2)
            }
        }

        Component.onCompleted: {
            currentIndex = 0
        }
    }

    EditWindow {
        id: editWindow
    }

    function changeMenu(index) {
        if(index === 1)
        {
            mainMenu.visible = !mainMenu.visible
            rawVideosMenu.visible = !rawVideosMenu.visible
            rawVideosMenu.currentIndex = 0
        }
        else if(index === 2)
        {
            mainMenu.visible = !mainMenu.visible
            editedVideosMenu.visible = !editedVideosMenu.visible
            editedVideosMenu.currentIndex = 0
        }
        else if(index === 9)
        {
            videoPlayer.visible = !videoPlayer.visible
        }
    }
}
