#include "dialogmodel.h"
#include "networkgenerator.h"

DialogModel::DialogModel(QObject* parent):QAbstractListModel(parent)
{
    //класс получения ответов по сети
    m_networkGenerator = new NetworkGenerator();
    m_networkGenerator->moveToThread(m_thread);

    // поток получения ответов
    m_thread = new QThread();
    connect(m_thread,&QThread::started,m_networkGenerator,&NetworkGenerator::start);

    //прекращение работы потока получения ответов
    connect(m_networkGenerator,&NetworkGenerator::stopped,m_thread,&QThread::quit);

    //переправление начальное и ответное сообщение из потока в модель
    connect(m_networkGenerator,SIGNAL(receiveResponseMessage(const QString&, const QString&)),
            this, SLOT(addNewRows(const QString&, const QString&)));

    //Очищаем диалог
    m_dialogData.clear();
}

DialogModel::~DialogModel()
{
    //Останавливаем поток получения ответных сообщений
    m_networkGenerator->stop();
    delete m_networkGenerator;
}

//количество сообщений
int DialogModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
    {
        return 0;
    }

    return m_dialogData.size();
}

//данные модели диалога
QVariant DialogModel::data(const QModelIndex &index, int role) const
{
    if ((!index.isValid()) || (index.row() <0) || (index.row() > m_dialogData.size()-1))
    {
        return QVariant();
    }

    switch (role)
    {
        case Qt::DisplayRole:
        {
            return m_dialogData.at(index.row());
            break;
        }
        default:
        {
            return QVariant();
        }
    }

    return QVariant();
}

//Получение сообщения от пользователя из QML
void DialogModel::receiveMessage(const QVariant& userMessage)
{
    //отправляем запрос от пользователя
    m_networkGenerator->setStringData(userMessage);

    //запускаем поток получения ответов
    if (m_networkGenerator->m_started == false)
    {
        QMetaObject::invokeMethod(m_thread,"start",Qt::DirectConnection);
    }
}

//очистка списка сообщений и модели диалога
void DialogModel::clearConversation()
{
    if (m_dialogData.size()>0)
    {
        beginRemoveRows(QModelIndex(),0,m_dialogData.size()-1);
        m_dialogData.clear();
        endRemoveRows();
        m_networkGenerator->stop();     
    }
    emit dataSizeChanged(m_dialogData.size()-1);
}

//Расширяем список сообщений и модель диалога
void DialogModel::addNewRows(const QString& inputMessage, const QString& outputMessage)
{
    beginInsertRows(QModelIndex(),m_dialogData.size(),m_dialogData.size()+1);
    m_dialogData.append(inputMessage);
    m_dialogData.append(outputMessage);
    endInsertRows();

    emit dataSizeChanged(m_dialogData.size()-1);
}

//отправка в QML количества сообщений в диалоге
int DialogModel::getDataSize()
{
    return m_dialogData.size()-1;
}
