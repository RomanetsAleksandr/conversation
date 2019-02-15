#ifndef NETWORKGENERATOR_H
#define NETWORKGENERATOR_H

#include <iostream>
#include <queue>

#include <QtCore>
#include <QtNetwork>
#include <QtXml>

class NetworkGenerator : public QObject
{
    Q_OBJECT

public:
    NetworkGenerator(QObject* parent = nullptr);
    ~NetworkGenerator();

signals:
    //сигнал остановки потока
    void stopped();
    //сигнал отправки сообщения и ответа в модель
    void receiveResponseMessage(const QString&, const QString&);

public:
    //прием сообщения от пользователя
    void setStringData(const QVariant& userMessage);
    //остановка потока получения ответов
    void stop();
    //флаг запуска потока получения ответов
    bool m_started;

public slots:
    //запуск потока получения ответов
    void start();

private slots:
    //ответ получен
    void onFinished(QNetworkReply* reply);

private:
    //парсер XML документа при определении ответа outputMessage
    void traverseNode(const QDomNode& node);

    //очередь сообщений
    std::queue<QString> userMessageQueue;

    //флаг соединения с сетью при получении ответа
    bool m_connect;

    //соообщение
    QString inputMessage;
    //ответ
    QString outputMessage;    
    QNetworkAccessManager m_manager;
};
#endif // NETWORKGENERATOR_H
