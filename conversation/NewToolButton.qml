import QtQuick 2.0

Rectangle
{
    id: toolButton

    property alias source: image.source
    property int mainX : 0
    property int mainHeight : 0

    x: mainX
    width: mainHeight
    height: mainHeight
    color: "transparent"

    signal clicked

    Image
    {
        id: image
        anchors.verticalCenter: toolButton.verticalCenter
        anchors.horizontalCenter: toolButton.horizontalCenter
        source: "qrc:/images/next.png"
    }

    MouseArea
    {
        id: regionToolButton
        anchors.fill: toolButton
        onClicked:
        {
            toolButton.clicked()
        }
    }

    states:
    [
        State
        {
            name: "pressed"
            when: regionToolButton.pressed
            PropertyChanges
            {
                target: toolButton;
                color: palette.highlight
            }
        }
    ]
}
