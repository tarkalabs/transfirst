require 'savon'

##
# Provides basic facility to create a Savon Client wrapping
# the reports WSDL endpoint
class Transfirst::Reports::Base

  attr_reader :client, :gateway_id, :registration_key

  NAMESPACES = {
    "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
    "xmlns:tran"=>"http://transfirst.com",
    "xmlns:erep"=>"http://schemas.datacontract.org/2004/07/eReportsDC",
    "xmlns:erep1"=>"http://schemas.datacontract.org/2004/07/eReportsEnum"
  }

  def initialize(credentials = {})
    @gateway_id = credentials.fetch(:gateway_id)
    @registration_key = credentials.fetch(:registration_key)
  end

  def soap_client
    document=wsdl_path
    @client ||= Savon::Client.new do
      ssl_verify_mode :none
      log true if ENV['DEBUG']
      pretty_print_xml true
      wsdl document
    end
  end

  def make_request(op_name,soap_action,to_wrap)
    response = soap_client.call(op_name,soap_action: soap_action, xml: to_wrap)
    response.body
  end

  private

  def wsdl_path
    File.expand_path(File.join(__FILE__,'../../../wsdl/reports.wsdl'))
  end
end
