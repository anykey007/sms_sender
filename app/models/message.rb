# encoding: utf-8
class Message < ActiveRecord::Base
  require 'nokogiri'
  attr_accessible :status, :text, :messageble_id, :messageble_type

  belongs_to :messageble

  default_scope { order('id DESC') }

  MESSAGE_STATUSES =
  {
    "DELIVERED" => "все части сообщения успешно доставлены получателю",
    "EXPIRED" => "Срок жизни сообщения вышел, сообщения не доставлено получателю",
    "UNDELIV" => "Сообщение не может быть доставлено. Чаще всего эта ошибка возникает, когда номер абонента не верен, либо абонент отключен",
    "ALFANAMELIMITED" => "Сообщение не может быть отправлено абоненту Life :), так как Альфаимя ограничено",
    "STOPED" => "Сообщение остановлено системой. Чаще всего это происходит, если у клиента недостаточно средств для отправки сообщения",
    "USERSTOPED" => "Сообщение остановлено пользователем через WEB интерфейс",
    "ERROR" => "Системная ошибка при отправке сообщения",
    "PENDING" => "Сообщение в очереди на отправку",
    "SENT" => "Сообщение отправлено абоненту. Ожидается статус сообщения от оператора"
  }

  def recipients
    rec = []
    node_set = Nokogiri::XML(request)    
    node_set.xpath('request/message/recipient').each do |recipient|
      rec << recipient.content
    end
    rec
  end

  def recipients_status
    Hash[*recipients.map{|rec| [rec,SMS.check_status(campaign_id, rec)]}.flatten]
  end

  def recipients_by_status(status)
    recipients_status.find_all{ |key, value| value == status }
  end

  def client_type?
    self.messageble_type=='Client'
  end

  def group_type?
    self.messageble_type=='Group'
  end

  def campaign_id
    node_set = Nokogiri::XML(response)
    campaignID = node_set.xpath('/message/state').first['campaignID']
  end

  before_create do |message|
    case message.messageble_type
      when 'Client'
        client = Client.find(message.messageble_id)
        recipients = [client.phone]
        result, request, response = SMS.send_sms(message.text, recipients, 'desc')
        message.status = result
        message.request = request
        message.response = response
      when 'Group'
        recipients = Group.find(message.messageble_id).clients.pluck(:phone)
        result, request, response = SMS.send_sms(message.text, recipients, 'desc')
        message.status = result
        message.request = request
        message.response = response
      else 
        # false
    end
  end
end
