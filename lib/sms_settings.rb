# encoding: utf-8
RESPONSE_MESSAGES =
{
  "ACCEPT"=>"сообщение принято системой и поставлено в очередь на формирование рассылки",
  "XMLERROR"=>"Некорректный XML",
  "ERRPHONES"=>"Неверно задан номер получателя",
  "ERRSTARTTIME"=>"не корректное время начала отправки",
  "ERRENDTIME"=>"не корректное время окончания рассылки",
  "ERRLIVETIME"=>"не корректное время жизни сообщения",
  "ERRSPEED"=>"не корректная скорость отправки сообщений",
  "ERRALFANAME"=>"данное альфанумерическое имя использовать запрещено, либо ошибка",
  "ERRTEXT"=>"некорректный текст сообщения",
  "ERR"=>"произошла ошибка"
}

ALFANAME = "SMS"

API_URL = 'http://sms-fly.com/api/api.php'
AUTH_NAME = '380504424263'
AUTH_PASSWORD = '123'

SMS_FLY_TARIFF = 0.12
OUR_TARIFF = 0.15

LOGS_DIR = "#{Rails.root}/log/sms"