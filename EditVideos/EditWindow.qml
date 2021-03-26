import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtAV 1.6

Window {
    id: editWindow
    width: 640
    height: 480
    visible: false
    title: qsTr("Video Editor")

    property string videoName: ""
    property string videoPath: ""
    property string videoThumbPath: ""

    property bool decreasing: false

    Video {
        id: videoPlayer
        anchors.fill: parent

        onStopped: {
            stopRendering();
        }
    }

        Image {
            id: videoThumbnail
            source: videoThumbPath

            onStatusChanged: {
                if (status == Image.Ready) {
                   editWindow.setHeight(sourceSize.height)
                   editWindow.setWidth(sourceSize.width)
                   editWindow.maximumHeight = editWindow.height
                   editWindow.minimumHeight = editWindow.height
                   editWindow.maximumWidth = editWindow.width
                   editWindow.minimumWidth = editWindow.width
                }
            }

        Rectangle {
            id: textOverlaySelection
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10
            anchors.topMargin: 10
            width: 150
            height: 150
            color: Qt.rgba(1, 1, 1, 0.7)

            ColumnLayout {
                RowLayout {
                    CheckBox {
                        id: textCheckbox
                        text: ""
                        checked: false
                    }

                    Text {
                        text: "Text"
                        color: Qt.rgba(0, 0, 0, 1)
                    }
                }

                RowLayout {
                    Item {
                        implicitWidth: 10
                        implicitHeight: 10
                    }

                    Text {
                        text: "X: "
                        color: Qt.rgba(0, 0, 0, 1)
                    }

                    TextField {
                        implicitWidth: 100
                        text: "0"
                        validator: IntValidator { bottom: 0; top: editWindow.width }

                        onTextChanged: {
                            textOverlay.x = text*1
                        }
                    }
                }

                RowLayout {
                    Item {
                        implicitWidth: 10
                        implicitHeight: 10
                    }

                    Text {
                        text: "Y: "
                        color: Qt.rgba(0, 0, 0, 1)
                    }

                    TextField {
                        implicitWidth: 100
                        text: "0"
                        validator: IntValidator { bottom: 0; top: editWindow.height }

                        onTextChanged: {
                            textOverlay.y = text*1
                        }
                    }
                }
            }
        }

        Rectangle {
            id: rectangleOverlaySelection
            anchors.left: parent.left
            anchors.top: textOverlaySelection.bottom
            anchors.leftMargin: 10
            anchors.topMargin: 10
            width: 150
            height: 150
            color: Qt.rgba(1, 1, 1, 0.7)

            ColumnLayout {
                RowLayout {
                    CheckBox {
                        id: rectangleCheckbox
                        text: ""
                        checked: false
                    }

                    Text {
                        text: "Rectangle"
                        color: Qt.rgba(0, 0, 0, 1)
                    }
                }

                RowLayout {
                    Item {
                        implicitWidth: 10
                        implicitHeight: 10
                    }

                    Text {
                        text: "X: "
                        color: Qt.rgba(0, 0, 0, 1)
                    }

                    TextField {
                        implicitWidth: 100
                        text: "0"
                        validator: IntValidator { bottom: 0; top: editWindow.width }

                        onTextChanged: {
                            rectangleOverlay.x = text*1
                        }
                    }
                }

                RowLayout {
                    Item {
                        implicitWidth: 10
                        implicitHeight: 10
                    }

                    Text {
                        text: "Y: "
                        color: Qt.rgba(0, 0, 0, 1)
                    }

                    TextField {
                        implicitWidth: 100
                        text: "0"
                        validator: IntValidator { bottom: 0; top: editWindow.height }

                        onTextChanged: {
                            rectangleOverlay.y = text*1
                        }
                    }
                }
            }
        }

        Rectangle {
            id: progressbarOverlaySelection
            anchors.left: parent.left
            anchors.top: rectangleOverlaySelection.bottom
            anchors.leftMargin: 10
            anchors.topMargin: 10
            width: 150
            height: 150
            color: Qt.rgba(1, 1, 1, 0.7)

            ColumnLayout {
                RowLayout {
                    CheckBox {
                        id: progressbarCheckbox
                        text: ""
                        checked: false
                    }

                    Text {
                        text: "Progress Bar"
                        color: Qt.rgba(0, 0, 0, 1)
                    }
                }

                RowLayout {
                    Item {
                        implicitWidth: 10
                        implicitHeight: 10
                    }

                    Text {
                        text: "X: "
                        color: Qt.rgba(0, 0, 0, 1)
                    }

                    TextField {
                        implicitWidth: 100
                        text: "0"
                        validator: IntValidator { bottom: 0; top: editWindow.width }

                        onTextChanged: {
                            progressbarOverlay.x = text*1
                        }
                    }
                }

                RowLayout {
                    Item {
                        implicitWidth: 10
                        implicitHeight: 10
                    }

                    Text {
                        text: "Y: "
                        color: Qt.rgba(0, 0, 0, 1)
                    }

                    TextField {
                        implicitWidth: 100
                        text: "0"
                        validator: IntValidator { bottom: 0; top: editWindow.height }

                        onTextChanged: {
                            progressbarOverlay.y = text*1
                        }
                    }
                }
                Item {
                    implicitWidth: 5
                    implicitHeight: 20
                }

                Button {
                    text: "Render"

                    onClicked: {
                        startRendering();
                    }
                }
            }
        }
    }

    Text {
        id: textOverlay
        text: "Random"
        color: Qt.rgba(1, 1, 1, 1)
    }

    Rectangle {
        id: rectangleOverlay
        width: 50
        height: 50

        property color gradColorOne: Qt.rgba(0, 0, 0, 1)
        property color gradColorTwo: Qt.rgba(1, 1, 1, 1)

        gradient: Gradient {
            GradientStop { position: 0; color: rectangleOverlay.gradColorOne }
            GradientStop { position: 1; color: rectangleOverlay.gradColorTwo }
        }
    }

    ProgressBar {
        id: progressbarOverlay
        value: 0
    }

    Timer {
        id: recordTimer
        interval: 5
        running: false
        repeat: true

        onTriggered: {
            if (false === videoEditor.record(editWindow, videoName))
            {
                recordTimer.stop();
                screenrecordObj.endRecord();
            }
        }
    }

    Timer {
        id: textChangeTimer

        interval: 300
        running: false
        repeat: true

        onTriggered: {
            textOverlay.text = Math.floor(Math.random() * Math.floor(100));
        }
    }

    Timer {
        id: rectangleChangeTimer

        interval: 1000
        running: false
        repeat: true

        onTriggered: {
            rectangleOverlay.x = Math.floor(Math.random() * Math.floor(editWindow.width - rectangleOverlay.width));
            rectangleOverlay.y = Math.floor(Math.random() * Math.floor(editWindow.height - rectangleOverlay.height));
            rectangleOverlay.gradColorOne = Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
            rectangleOverlay.gradColorTwo = Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
        }
    }

    Timer {
        id: progressbarChangeTimer

        interval: 500
        running: false
        repeat: true

        onTriggered: {
            if(progressbarOverlay.value < 0.9999999 && decreasing === false)
                progressbarOverlay.value += 0.1
            else if(progressbarOverlay.value > 0 && decreasing)
                progressbarOverlay.value -= 0.1
            else if(progressbarOverlay.value === 0)
                decreasing = false
            else
                decreasing = true
        }
    }

    Window {
        id: renderingPopup
        width: 400
        height: 150
        title: "Rendering"
        modality: Qt.ApplicationModal

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Rendering video, do not close the application windows!"
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height - 70
            text: "Abort Rendering"

            onClicked: {
                abortRendering();
            }
        }
    }


    function startRendering() {
        renderingPopup.show()

        textOverlaySelection.visible = false
        rectangleOverlaySelection.visible = false
        progressbarOverlaySelection.visible = false

        textOverlay.visible = textCheckbox.checked
        rectangleOverlay.visible = rectangleCheckbox.checked
        progressbarOverlay.visible = progressbarCheckbox.checked

        if(textCheckbox) textChangeTimer.start()
        if(rectangleCheckbox) rectangleChangeTimer.start();
        if(progressbarCheckbox) progressbarChangeTimer.start();

        videoPlayer.source = videoPath
        videoThumbnail.visible = false
        videoPlayer.visible = true
        videoPlayer.play()
        recordTimer.start()
    }

    function stopRendering() {
        recordTimer.stop()
        videoEditor.endRecord();

        videoPlayer.source = ""
        videoPlayer.visible = false
        videoThumbnail.visible = true
        textOverlaySelection.visible = true
        rectangleOverlaySelection.visible = true
        progressbarOverlaySelection.visible = true

        textOverlay.visible = true
        rectangleOverlay.visible = true
        progressbarOverlay.visible = true

        textChangeTimer.stop()
        rectangleChangeTimer.stop();
        progressbarChangeTimer.stop();

        videoLoader.addNewEditedVideo(videoName);
        videoEditor.extractVideoSound(videoName);

        renderingPopup.close()
    }

    function abortRendering() {
        recordTimer.stop()
        videoEditor.endRecord();

        videoPlayer.stop()
        videoPlayer.source = ""
        videoPlayer.visible = false
        videoThumbnail.visible = true
        textOverlaySelection.visible = true
        rectangleOverlaySelection.visible = true
        progressbarOverlaySelection.visible = true

        textOverlay.visible = true
        rectangleOverlay.visible = true
        progressbarOverlay.visible = true

        textChangeTimer.stop()
        rectangleChangeTimer.stop();
        progressbarChangeTimer.stop();

        renderingPopup.close()
    }
}
