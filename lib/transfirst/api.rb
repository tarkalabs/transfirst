require 'savon'

class Transfirst::API
  VERSION='v1'
  MERCHANT_WEB_SERVICE = 1
  XSD_PATH="http://postilion/realtime/merchantframework/xsd/v1/"

  attr_reader :client, :gateway_id, :registration_key

  def initialize(credentials = {})
    @gateway_id = credentials.fetch(:gateway_id)
    @registration_key = credentials.fetch(:registration_key)
  end

  def make_request(opname, method, *to_wrap)
    body = build_request(method, *to_wrap)
    begin
      response = soap_client.call(opname, xml: body, soap_action: nil)
      response.body
    rescue Savon::SOAPFault => e
      puts "===========" * 10
      puts body
      puts "===========" * 10

      raise Transfirst::TransfirstError.new(e)
    end
  end

  private
  def soap_client
    document=wsdl_path
    @client ||= Savon::Client.new do
      ssl_verify_mode :none
      log true if ENV['DEBUG']
      pretty_print_xml true
      wsdl document
    end
  end

  def build_request(method, *to_wrap)
    namespaces = {
      "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
      "xmlns:#{VERSION}" => XSD_PATH
    }
    req_builder = Nokogiri::XML::Builder.new do |xml|
      xml['soapenv'].Envelope(namespaces) do
        xml['soapenv'].Header
        xml['soapenv'].Body do
          xml[VERSION].send(method) do
            xml[VERSION].merc do
              xml[VERSION].id gateway_id
              xml[VERSION].regKey registration_key
              xml[VERSION].inType MERCHANT_WEB_SERVICE
            end
            to_wrap.each do |node|
              xml << node
            end
          end
        end
      end
    end
    req_builder.to_xml :save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
  end

  def wsdl_path
    File.expand_path(File.join(__FILE__,'../../wsdl/transfirst-v1.wsdl'))
  end
end
