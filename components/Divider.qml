import QtQuick
import QtQuick.Layouts
import "root:services"

Rectangle {
    id: root

    Layout.preferredWidth: 1
    Layout.preferredHeight: parent ? parent.height * 0.4 : 12
    Layout.alignment: Qt.AlignVCenter
    Layout.leftMargin: 8
    Layout.rightMargin: 8

    color: Theme.foreground
    opacity: 0.3
}
