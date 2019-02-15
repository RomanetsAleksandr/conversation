#include "networkgenerator.h"

NetworkGenerator::NetworkGenerator(QObject* parent):QObject(nullptr)
{
    m_started     = false;
    m_connect     = false;
    inputMessage  = "";
    outputMessage = "";
    connect(&m_manager,SIGNAL(finished(QNetworkReply*)),SLOT(onFinished(QNetworkReply*)));
}

NetworkGenerator::~NetworkGenerator()
{
}

//парсер XML документа при определении ответа outputMessage
void NetworkGenerator::traverseNode(const QDomNode& node)
{
    QDomNode domNode = node.firstChild();
    while (!domNode.isNull())
    {
        if (domNode.isElement())
        {
            QDomElement domElement = domNode.toElement();

            if (!domElement.isNull())
            {
                if (domElement.tagName() == "response")
                {
                    outputMessage = "Bot: "+domElement.text();
                }
            }
        }
        traverseNode(domNode);
        domNode = domNode.nextSibling();
    }
}

//запуск потока получения ответов
void NetworkGenerator::start()
{
    m_started = true;

    while (m_started == true)
    {
        while(userMessageQueue.size()>0 && m_started == true)
        {
            //отправляем запрос на ответ
            m_connect = true; 
            inputMessage = userMessageQueue.front();
            QString outputUrl = "http://host1.demoproject2f.techcd.ru/chatbot/conversation_start.php?bot_id=2&say='%1'&format=xml&Name='%2'";
            outputUrl = outputUrl.arg((inputMessage).split(':').at(1)).arg((inputMessage).split(':').at(0));
            m_manager.get(QNetworkRequest(QUrl(outputUrl)));

            while (m_connect == true)
            {
                QCoreApplication::processEvents();
            }      
            userMessageQueue.pop();
            //////////////////////////
        }
    }

    //очищаем очередь запросов от пользователя при остановке потока
    while (userMessageQueue.size() != 0)
    {
        userMessageQueue.pop();
    }
    emit stopped();
}

//прием сообщения от пользователя
void NetworkGenerator::setStringData(const QVariant& userMessage)
{
    userMessageQueue.push(userMessage.toString());
}

//остановка потока получения ответов
void NetworkGenerator::stop()
{
    m_started = false;
}

//ответ получен
void NetworkGenerator::onFinished(QNetworkReply* reply)
{
    QString fullOutputMessage;
    if (reply->error() == QNetworkReply::NoError)
    {
        //получаем полный ответ
        fullOutputMessage = QString::fromUtf8(reply->readAll());

        //кладем полный ответ в XML документ и получаем нужный ответ
        QDomDocument domDoc;
        if (domDoc.setContent(fullOutputMessage.toLocal8Bit()))
        {
            QDomElement domElement = domDoc.documentElement();
            traverseNode(domElement);
            //отправляем сообщение и ответ outputMessage в модель
            emit receiveResponseMessage(inputMessage,outputMessage);
        }
    }
    reply->deleteLater();
    m_connect = false;
}
