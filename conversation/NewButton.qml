import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

Item
{
    id: newbutton

    property string name: ""
    property alias text: buttonText.text
    property string outputMessage: ""
    property real fontSize: 18

    signal clicked

    property int mainWidth  : 0
    property int mainHeight  : 1.7*itemHeight

    Button
    {
        id: buttonText
        width: newbutton.mainWidth
        height: newbutton.mainHeight

        style: ButtonStyle
        {
            label: Component
            {
                Text
                {
                    text: buttonText.text
                    color: "black"
                    font.pointSize: fontSize
                    clip: true
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                }
            }

            //Стилизуем кнопку
            background: Rectangle
            {
                /* Если кнопка нажата, то она будет белого цвета
                 * с серым ободком со скруглёнными краями,
                 * в противном случае она будет серого цвета
                 */
                color:
                {
                    if (name == "clear button")
                    {
                        return control.pressed ?  "white" :"#FFC004"
                    }
                    else
                    {
                        if (outputMessage != "")
                        {
                            return control.pressed ?  "white" :"#FFC004"
                        }
                        else
                        {
                            return "#FFC004"
                        }
                    }
                }
                border.color: "gray"
                border.width: 2
                radius: 3
            }

        }
        onClicked: newbutton.clicked()
    }
}
