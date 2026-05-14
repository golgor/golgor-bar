import QtQuick
import QtQuick.Layouts
import "root:services"
import "root:utils"

Item {
    id: root

    signal clicked()

    implicitWidth: clockLabel.implicitWidth
    implicitHeight: parent.height

    property date now: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Text {
        id: clockLabel

        anchors.centerIn: parent
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize

        text: {
            const weekNum = DateUtils.weekNumber(root.now);
            return Qt.formatDateTime(root.now, "dddd dd MMMM yyyy") + " | W" + weekNum + " · " + Qt.formatDateTime(root.now, "hh:mm");
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
