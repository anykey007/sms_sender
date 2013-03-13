# encoding: utf-8
module SMS
  require 'net/http'
  require 'uri'
  require 'builder'
  require 'nokogiri'
  require 'sms_settings'

  def self.get_balance
    output = ""
    xml = Builder::XmlMarkup.new(:target => output, :ident => 2)
    xml.instruct! :xml, :encoding => "utf-8"
    xml.request do |p|
        xml.operation 'GETBALANCE'
    end

    response = send_request(output)

    node_set = Nokogiri::XML(response.body)
    balance = node_set.xpath('/message/balance').first.text.to_f

    [(balance*SMS_FLY_TARIFF/OUR_TARIFF).round(2),(balance/OUR_TARIFF).round(0)]
  end

  def self.check_status(campaignID, recipient)
    output = ""
    xml = Builder::XmlMarkup.new(:target => output, :ident => 2)
    xml.instruct! :xml, :encoding => "utf-8"
    xml.request do |p|
        p.operation 'GETMESSAGESTATUS'
        p.message(campaignID: campaignID, recipient: recipient)
    end    

    response = self.send_request(output)
    node_set = Nokogiri::XML(response.body)
    node_set.xpath('/message/state').first['status']
  end

  def self.build_xml(text, recipients, desc)
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "utf-8"
    xml.request do |p|
        xml.operation 'SENDSMS'        
        xml.message(start_time: 5.hours.from_now.strftime('%Y-%m-%d %H:%M:%S'), end_time: 6.hours.from_now.strftime('%Y-%m-%d %H:%M:%S'), livetime: "4", rate: "120", desc: desc, source: ALFANAME) do |p|
        # xml.message(start_time: "AUTO", end_time: "AUTO", livetime: "4", rate: "120", desc: desc, source: ALFANAME) do |p|
            xml.body text
            recipients.each do |recipient|
                xml.recipient recipient
            end
        end
    end
    
  end

  def self.send_request(xml_body)
    url = URI.parse(API_URL)
    request = Net::HTTP::Post.new(url.path)
    request.basic_auth AUTH_NAME, AUTH_PASSWORD
    request.set_content_type('text/xml', { 'charset' => 'utf-8' })
    request.body = xml_body
    response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}      
  end

  def SMS.send_sms(text, recipients, desc)
    xml_body = self.build_xml(text, recipients, desc)
    response = self.send_request(xml_body)    
    result = self.check_response(response)  
    [result, xml_body, response.body]  
  end

  def self.check_response(response)
    if response.body.present?
        node_set = Nokogiri::XML(response.body)
        code = node_set.xpath('/message/state').first['code']
        RESPONSE_MESSAGES[code]
    else
        RESPONSE_MESSAGES["ERR"]
    end

  end
end