#ifndef DIALOGMODEL_H
#define DIALOGMODEL_H

#include <QAbstractListModel>

//опережающее объявление
class NetworkGenerator;

class DialogModel : public QAbstractListModel
{
    Q_OBJECT

public:
    DialogModel(QObject* parent = 0);
    ~DialogModel();

    //количество сообщений
    virtual int rowCount(const QModelIndex& parent) const;

    //данные модели диалога
    virtual QVariant data(const QModelIndex& index, int role) const;

    //Получение сообщения от пользователя из QML
    Q_INVOKABLE void receiveMessage(const QVariant& userMessage);

    //очистка диалога
    Q_INVOKABLE void clearConversation();

    //вывод в QML количество сообщений в диалоге
    Q_INVOKABLE int getDataSize();

signals:
    //сигнал в QML, говорящий о изменении количества сообщений в диалоге
    void dataSizeChanged(int);

private slots:
    //добавляем новые сообщения в диалог
    void addNewRows(const QString& inputMessage, const QString& outputMessage);

private:
    //список сообщений диалога
    QStringList m_dialogData;

    //Поток в котором получаются ответные сообщения
    QThread* m_thread;

    //Класс соединения с сетью
    NetworkGenerator* m_networkGenerator;
};

#endif // DIALOGMODEL_H
