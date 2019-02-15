import QtQuick 2.1
import QtQuick.Controls 1.0

Item
{
    id: newLabel
    property alias text: textLabel.text
    property alias color: textLabel.color
    property real fontSize: 18

    width: textLabel.Width
    height: textLabel.Height

    Label
    {
        id: textLabel
        font.pixelSize: fontSize
        font.bold: false
        anchors.horizontalCenter: newLabel.horizontalCenter
        anchors.verticalCenter:   newLabel.verticalCenter
    }
}
