import QtQuick 2.0

Rectangle
{
    id: rectText
    property alias text: inputText.text
    x: scaledMargin
    height: 1.7*itemHeight
    color: "white"
    border.color: "#252422"
    border.width: 2

    TextInput
    {
        id: inputText
        anchors.fill: rectText
        height: rectText.height

        font.pixelSize: genFontSize
        text: ""
        focus: true
        color: "black"
    }
}
