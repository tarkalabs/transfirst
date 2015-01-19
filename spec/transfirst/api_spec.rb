require 'spec_helper'
require 'equivalent-xml'
require 'pry'

RSpec.describe Transfirst::API do
  subject { Transfirst::API.new(gateway_id: '1234', registration_key: 'abcd') }

  describe "#initialization" do
    it "builds proper soap client on initialization" do
      expect(subject.client).to be
      expect(subject.gateway_id).to eq('1234')
      expect(subject.registration_key).to eq('abcd')
    end
  end
  describe "#build_request" do
    it "should build a proper xml request" do
      expected_xml = <<-REQUEST
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://postilion/realtime/merchantframework/xsd/v1/">
          <soapenv:Header/>
          <soapenv:Body> 
            <v1:UpdtRecurrProfRequest>
              <v1:merc>
                <v1:id>1234</v1:id> <v1:regKey>abcd</v1:regKey><v1:inType>1</v1:inType>
              </v1:merc>
              <v1:cust>
                <v1:type>0</v1:type>
                <v1:contact>
                  <v1:fullName>Juan Marichal</v1:fullName> <v1:phone>
                    <v1:type>3</v1:type> <v1:nr>5555555555</v1:nr>
                  </v1:phone>
                  <v1:addrLn1>12202 Airport Way</v1:addrLn1> 
                  <v1:addrLn2>Suite 100</v1:addrLn2> 
                  <v1:city>Broomfield</v1:city> 
                  <v1:state>CO</v1:state> 
                  <v1:zipCode>80021</v1:zipCode> 
                  <v1:ctry>US</v1:ctry> 
                  <v1:email>test@mail.com</v1:email> 
                  <v1:type>1</v1:type>
                  <v1:stat>1</v1:stat>
                </v1:contact>
              </v1:cust>
            </v1:UpdtRecurrProfRequest> 
          </soapenv:Body>
        </soapenv:Envelope>
      REQUEST
      customer_request = <<-CUSTOMER_REQUEST
        <v1:cust>
          <v1:type>0</v1:type>
          <v1:contact>
            <v1:fullName>Juan Marichal</v1:fullName> <v1:phone>
              <v1:type>3</v1:type> <v1:nr>5555555555</v1:nr>
            </v1:phone>
            <v1:addrLn1>12202 Airport Way</v1:addrLn1> 
            <v1:addrLn2>Suite 100</v1:addrLn2> 
            <v1:city>Broomfield</v1:city> 
            <v1:state>CO</v1:state> 
            <v1:zipCode>80021</v1:zipCode> 
            <v1:ctry>US</v1:ctry> 
            <v1:email>test@mail.com</v1:email> 
            <v1:type>1</v1:type>
            <v1:stat>1</v1:stat>
          </v1:contact>
        </v1:cust>
      CUSTOMER_REQUEST
      xml_request = subject.build_request('UpdtRecurrProfRequest',customer_request)
      # binding.pry
      expect(xml_request).to be_equivalent_to(Nokogiri::XML(expected_xml))
    end
  end
end
