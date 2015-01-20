require 'spec_helper'

RSpec.describe Transfirst::Customer do
  subject {
    Transfirst::Customer.new({
        full_name: "Juan Marichal",
        phone_number: 5555555555,
        address_line1: "12202 Airport Way",
        address_line2: "Suite 100",
        city: "Broomfield",
        state: "CO",
        zip_code: "80021",
        country: "US",
        email: "test@mail.com",
      })
  }
  describe "#to_xml" do
    it "serializes the customer as a xml object" do
      expected_xml = File.read('spec/fixtures/customer_request.xml')
      actual_xml = subject.to_xml
      expect(actual_xml).to be_equivalent_to(Nokogiri::XML(expected_xml))
    end
  end

  describe "#register" do

    context "api is not set" do
      it "expects error if the api object is not set" do
        expect { subject.register }.to raise_error(Transfirst::Customer::NO_API_ERROR)
      end
    end

    context "api is set" do
      it "should call build request on api" do
        customer_xml = subject.to_xml
        api = double(:api)
        mock_response = {:updt_recurr_prof_response=>
          {:cust_id=>"1421783307054197961",
           :rsp_code=>"00",
           :@xmlns=>"http://postilion/realtime/portal/soa/xsd/Faults/2009/01",
           :"@xmlns:ns2"=>"http://postilion/realtime/merchantframework/xsd/v1/"}}
        expect(api).to receive(:make_request).with(:updt_recurr_prof,'UpdtRecurrProfRequest', customer_xml)
                                             .and_return(mock_response)
        subject.api=api
        return_obj=subject.register
        expect(return_obj).to eq(subject)
        expect(return_obj.tf_id).to eq("1421783307054197961")
      end
    end

  end
end