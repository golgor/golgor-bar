import QtQuick
import QtQuick.Layouts
import "root:services"
import "root:utils"

Item {
    id: root

    signal clicked()

    implicitWidth: clockLabel.implicitWidth
    implicitHeight: bar.height

    Text {
        id: clockLabel

        anchors.centerIn: parent
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize

        text: {
            const now = new Date();
            const locale = Qt.locale();
            const weekNum = DateUtils.weekNumber(now);
            return Qt.formatDateTime(now, "dddd dd MMMM yyyy") + " | W" + weekNum + " · " + Qt.formatDateTime(now, "hh:mm");
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockLabel.text = Qt.binding(() => {
            const now = new Date();
            const weekNum = DateUtils.weekNumber(now);
            return Qt.formatDateTime(now, "dddd dd MMMM yyyy") + " | W" + weekNum + " · " + Qt.formatDateTime(now, "hh:mm");
        })
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
