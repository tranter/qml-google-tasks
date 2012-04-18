#ifndef DATETIMECONVERTER_H
#define DATETIMECONVERTER_H

#include <QObject>
#include <QDateTime>

class DateTimeConverter : public QObject
{
    Q_OBJECT
public:
    explicit DateTimeConverter(QObject *parent = 0);

public slots:
    void setHumanable(const QString &);
    void setRFC3339(const QString &);
    void setNow();
    void setToday();
    void setDate(int year, int month, int day);

public:
    Q_INVOKABLE QString toRFC3339() const;
    Q_INVOKABLE QString toHumanableFormat() const;

    Q_INVOKABLE int day()   const { return m_dt.date().day();   }
    Q_INVOKABLE int month() const { return m_dt.date().month(); }
    Q_INVOKABLE int year()  const { return m_dt.date().year();  }

private:
    QString m_RFC3339Format;
    QString m_outputFormat;
    QDateTime m_dt;
};

#endif // DATETIMECONVERTER_H
