require 'spec_helper'
require 'equivalent-xml'
require 'pry'

RSpec.describe Transfirst::API do
  subject { Transfirst::API.new(gateway_id: '1234', registration_key: 'abcd') }

  describe "#initialization" do
    it "builds proper soap client on initialization" do
      expect(subject.gateway_id).to eq('1234')
      expect(subject.registration_key).to eq('abcd')
    end
  end
  describe "#make_request" do
    it "should build a proper xml body and peform a soap request" do
      expected_xml = File.read('spec/fixtures/soap_request.xml')
      customer_request = File.read('spec/fixtures/customer_request.xml')
      mock_response = double(:response)
      client = double(:client)
      allow(subject).to receive(:soap_client).and_return(client)
      expect(mock_response).to receive(:body)
      expect(client).to receive(:call).with(:updt_recurr_prof,
                                             xml: be_equivalent_to(Nokogiri::XML(expected_xml).to_xml), 
                                             soap_action: nil)
                                      .and_return(mock_response)
      subject.make_request(:updt_recurr_prof,'UpdtRecurrProfRequest',customer_request)
    end
  end
end
