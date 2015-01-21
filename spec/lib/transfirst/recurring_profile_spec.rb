require 'spec_helper'

RSpec.describe Transfirst::RecurringProfile do
  subject {
    Transfirst::RecurringProfile.new(
      amount: 100,
      start_date: DateTime.new(2015,1,1),
      description: "desc",
      purchase_order_number: 1234,
      customer: Transfirst::Customer.new({tf_id: 1315270297974159982}),
      wallet: Transfirst::Wallet.new({
        tf_id: 1315271377706182291,
        order_number: '42'
        })
    )
  }
  describe "#xml_for_action" do
    context "register" do
      it "expects xml to be serialized properly" do
        expected_xml=File.read('spec/fixtures/recurring_profile_request.xml')
        actual_xml=subject.send(:xml_for_action,Transfirst::Base::ADD_ENTITY)
        expect(actual_xml).to be_equivalent_to(expected_xml)
      end
    end
    context "update" do
      it "expects xml to be serialized properly" do
        subject.tf_id=1234
        expected_xml=File.read('spec/fixtures/recurring_profile_request_update.xml')
        actual_xml=subject.send(:xml_for_action,Transfirst::Base::UPDATE_ENTITY)
        expect(actual_xml).to be_equivalent_to(expected_xml)
      end
    end
  end
end