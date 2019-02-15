import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window  2.1

ApplicationWindow
{
    id: appWindow

    height: 674
    width: 360
    minimumHeight: height
    minimumWidth:  width
    maximumHeight: height
    maximumWidth:  width
    color: "black"
    visible: true
    title: qsTr("Conversation")

    property int itemHeight:    25
    property int genFontSize:   24
    property int pixDens:       Math.ceil(Screen.pixelDensity)
    property int scaledMargin:  2*pixDens

    Column
    {
        id: controlColumn
        anchors.top: appWindow.top
        anchors.left: appWindow.left
        spacing: 10


        SystemPalette
        {
            id: palette
        }


        //titlebar
        Rectangle
        {
            id: titleBar
            color: "blue"
            width: parent.width
            height: 2.4*itemHeight

            Text
            {
                id: titleText
                anchors.verticalCenter: titleBar.verticalCenter
                anchors.horizontalCenter: titleBar.horizontalCenter
                color: "white"
                text: "Conversation"
                font.pixelSize: 2*genFontSize
                font.bold: false
            }

            NewToolButton
            {
                id: closeButton
                source: "qrc:/images/close.png"
                mainX : titleBar.width - 8*scaledMargin
                mainHeight : titleBar.height
                anchors.verticalCenter: titleBar.verticalCenter
                onClicked:
                {
                    Qt.quit(0)
                }
            }
        }

        //заставочное изображение
        Image
        {
            id: imageCaption
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/images/caption.png"
        }
        //////////////////////////////

        NewLabel
        {
            id: welcomeLabel
            text: "Welcome"
            color: "white"
            fontSize: 3*genFontSize

            width: appWindow.width
            height: 7*itemHeight
        }

        //ввод имени пользователя
        NewLabel
        {
            id: inputLabel
            text: "Enter user name:"
            color: "white"
            fontSize: genFontSize

            width: appWindow.width
            height: itemHeight
        }

        NewText
        {
            id: userNameText
            width: appWindow.width-2*scaledMargin
        }

        //Начинаем диалог
        NewButton
        {
            id: startButton
            outputMessage: userNameText.text
            name: "start button"
            text: "start"

            x: scaledMargin
            y: userNameText.y+userNameText.height+scaledMargin
            mainWidth  : appWindow.width-2*scaledMargin        
            fontSize: genFontSize

            onClicked:
            {
                if (userNameText.text != "")
                {
                    dialogBrowser.showDialogBrowser(userNameText.text)
                }
                userNameText.text = ""
            }
        }
    }

    //диалог сообщений
    DialogBrowser
    {
        id: dialogBrowser
        anchors.fill: parent
    }
}
