#include "DateTimeConverter.h"

DateTimeConverter::
DateTimeConverter(QObject *parent) :
    QObject(parent)
    ,m_RFC3339Format("yyyy-MM-ddThh:mm:ss.zzzZ")
    ,m_outputFormat("MMM d, yyyy")
    ,m_dt(QDateTime::currentDateTime())
{
}

void
DateTimeConverter::
setHumanable(const QString & text)
{
    m_dt = QDateTime::fromString(text, m_outputFormat);
}

void
DateTimeConverter::
setRFC3339(const QString & text)
{
    m_dt = QDateTime::fromString(text, m_RFC3339Format);
}

QString
DateTimeConverter::
toRFC3339() const
{
    return m_dt.toString(m_RFC3339Format);
}

QString
DateTimeConverter::
toHumanableFormat() const
{
    return m_dt.toString(m_outputFormat);
}

void
DateTimeConverter::
setNow()
{
    m_dt = QDateTime::currentDateTime();
}

void
DateTimeConverter::
setToday()
{
    m_dt = QDateTime( QDate::currentDate() );
}

void
DateTimeConverter::
setDate(int year, int month, int day)
{
    m_dt = QDateTime( QDate(year, month, day) );
}
