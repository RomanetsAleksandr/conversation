import QtQuick 2.1

Item
{
    id: dialogBrowser
    z: 4
    property string userName: ""
    property variant dialogView;  

    //загрузчик
    Loader
    {
        id: loader
    }
    ////////////

    //грузим диалог сообщений
    function showDialogBrowser(name)
    {
        loader.sourceComponent = dialogBrowserComponent
        loader.item.parent = dialogBrowser;
        loader.item.anchors.fill = dialogBrowser;
        userName = name
    }
    ////////////////////////////

    Component
    {
        id: dialogBrowserComponent

        Rectangle
        {
            id: root
            color: "black"

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

                NewToolButton
                {
                    id: returnButton
                    source: "qrc:/images/return.png"
                    mainX : scaledMargin
                    mainHeight : titleBar.height
                    anchors.verticalCenter: titleBar.verticalCenter
                    onClicked:
                    {
                        //выгружаем диалог сообщений
                        loader.sourceComponent = undefined
                    }
                }

                //символ диалога сообщений
                Image
                {
                    id: imageDialog
                    anchors.verticalCenter: titleBar.verticalCenter
                    source: "qrc:/images/dialog.png"
                    x: 10*scaledMargin
                }
                //////////////////////////////
            }
            //////////////////////////////////

            //interface
            Rectangle
            {
                id: splitter
                color: "#353535"
                width: titleBar.width
                height: 2
                anchors.top: titleBar.bottom
            }
            /////////////

            //dialog view
            ListView
            {
                id: dialogView
                anchors.top: splitter.bottom
                anchors.margins: 5
                spacing: 5
                height: root.height-titleBar.height-190
                width: root.width

                model: dialogModel

                delegate: Item
                {
                    id: listDelegate

                    width: dialogView.width
                    height: 1.5*itemHeight

                    Rectangle
                    {
                        id: rectDelegate
                        anchors.margins: 5
                        anchors.fill: parent
                        color: "black"

                        Text
                        {
                            font.pixelSize: genFontSize
                            color: "white"
                            text: model.display
                        }

                        //interface
                        Rectangle
                        {
                            id: underlineREct
                            color: "white"
                            width: rectDelegate.width
                            height: 1
                            x: 0
                            y: rectDelegate.height-3
                        }
                    }
                }

                Component.onCompleted:
                {
                    //фиксация последнего сообщения
                    if (dialogModel.getDataSize() != -1)
                        dialogView.currentIndex = dialogModel.getDataSize();
                }
            }
            ///////////////////

            //Сообщение пользователя
            NewLabel
            {
                id: messageLabel
                x: scaledMargin
                y: dialogView.y+dialogView.height+scaledMargin
                text: "Enter message:"
                color: "white"
                fontSize: genFontSize
                width: appWindow.width
                height: itemHeight
            }

            NewText
            {
                id: userMessageText
                y: messageLabel.y+messageLabel.height+scaledMargin
                width: root.width-2*scaledMargin
            }
            /////////////////////////

            //создаем новое сообщение
            NewButton
            {
                id: sayButton
                name: "say button"
                text: "say"
                outputMessage: userMessageText.text
                fontSize: genFontSize
                x: scaledMargin
                y: userMessageText.y+userMessageText.height+scaledMargin
                mainWidth  : root.width-2*scaledMargin
                onClicked:
                {
                    if (userMessageText.text != "")
                    {
                        dialogModel.receiveMessage(userName+": "+userMessageText.text);
                    }
                }
            }
            ///////////////////////////////

            //очищаем диалог
            NewButton
            {
                id: clearButton
                name: "clear button"
                text: "clear conversation"
                fontSize: genFontSize
                x: scaledMargin
                y: sayButton.y+sayButton.mainHeight+scaledMargin
                mainWidth  : root.width-2*scaledMargin
                onClicked:
                {
                    dialogModel.clearConversation();
                }
            }
            ///////////////////////////////

            //фиксация последнего сообщения
            Component.onCompleted:
            {
                dialogModel.dataSizeChanged.connect(dialogViewCurrentIndexChange);
            }

            function dialogViewCurrentIndexChange(index)
            {
                if (index != -1) dialogView.currentIndex = index;
            }
            /////////////////////////////////
        }
    }
}
