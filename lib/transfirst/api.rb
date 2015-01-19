require 'savon'
require 'nokogiri'

class Transfirst::API
  attr_reader :client, :gateway_id, :registration_key

  def initialize(credentials = {})
    @gateway_id = credentials.fetch(:gateway_id)
    @registration_key = credentials.fetch(:registration_key)

    document = wsdl_path
    @client = Savon::Client.new do
      wsdl document
    end
  end
  def build_request(method,to_wrap,xmlns='v1')
    namespaces = {
      "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
      "xmlns:#{xmlns}" => "http://postilion/realtime/merchantframework/xsd/v1/"
    }
    req_builder = Nokogiri::XML::Builder.new do |xml|
      xml['soapenv'].Envelope(namespaces) do
        xml['soapenv'].Header
        xml['soapenv'].Body do
          xml[xmlns].send(method) do
            xml[xmlns].merc do
              xml[xmlns].id gateway_id
              xml[xmlns].regKey registration_key
              xml[xmlns].inType 1
            end
            xml << to_wrap
          end
        end
      end
    end
    req_builder.to_xml
  end
  private
  def wsdl_path
    File.expand_path(File.join(__FILE__,'../../wsdl/transfirst-v1.wsdl'))
  end
  # def merc_details
  #   {
  #     gateway_id: ENV['TF_GATEWAY_ID']
  #     reg_key: ENV['TF_REGISTRATION_KEY']
  #   }
  # end
end