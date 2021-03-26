import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    color: "#141417"

    property string thumbnail: "Src"
    property string name: "Name"
    property bool editable: false


    signal itemClicked()
    signal returnToMainMenu()
    signal editItem()

    Rectangle {
        id: videoRect
        width: parent.width / 2
        height: parent.height /2
        anchors.centerIn: parent

        gradient: Gradient {
            GradientStop { position: 0.2; color: Qt.rgba(0.078, 0.078, 0.090, 0.5) }
            GradientStop { position: 0.3; color: Qt.rgba(0.211, 0.764, 1, 0.05) }
            GradientStop { position: 0.4; color: Qt.rgba(0.211, 0.764, 1, 0.075) }
            GradientStop { position: 0.5; color: Qt.rgba(0.211, 0.764, 1, 0.1) }
            GradientStop { position: 0.6; color: Qt.rgba(0.211, 0.764, 1, 0.15) }
            GradientStop { position: 0.7; color: Qt.rgba(0.211, 0.764, 1, 0.2) }
            GradientStop { position: 1; color: Qt.rgba(0.211, 0.764, 1, 0.5) }
        }

        Rectangle {
            height: 5
            width: parent.width + 50
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            color: Qt.rgba(0.211, 0.764, 1, 0.7)
        }

        Text {
            id: videoNameText
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height - 50
            text: name
            font.pixelSize: 30
            color: Qt.rgba(0.901, 0.913, 0.941, 1)
        }

        Image {
            id: img
            source: thumbnail
            width: parent.width / 1.2
            height: parent.height / 1.2
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: videoNameText.top
            anchors.bottomMargin: 0
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                itemClicked()
            }
        }
    }

    Rectangle {
        height: 35
        width: 100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: videoRect.bottom
        anchors.topMargin: 15
        visible: editable

        color: Qt.rgba(0.211, 0.764, 1, 0.7)

        Text {
            anchors.centerIn: parent
            text: "EDIT"
            font.pixelSize: 15
            color: Qt.rgba(0.901, 0.913, 0.941, 1)
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                editItem()
            }
        }
    }
}

