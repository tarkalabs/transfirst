require 'spec_helper'

RSpec.describe Transfirst::Wallet do
  subject {
    Transfirst::Wallet.new({
      customer: Transfirst::Customer.new({tf_id: 1315270297974159982}),
      card_number: "411111******1111",
      expiry: '1216',
      order_number: 'WalletCustRefID'
      })
  }

  describe "#xml_for_action" do
    context "register" do
      it "expects xml to be serialized properly" do
        expected_xml=File.read('spec/fixtures/wallet_request.xml')
        actual_xml=subject.send(:xml_for_action,Transfirst::Base::ADD_ENTITY)
        expect(actual_xml).to be_equivalent_to(expected_xml)
      end
    end

    context "update" do
      it "expects xml to be serialized properly" do
        subject.tf_id='abcd'
        expected_xml=File.read('spec/fixtures/wallet_request_update.xml')
        actual_xml=subject.send(:xml_for_action,Transfirst::Base::UPDATE_ENTITY)
        expect(actual_xml).to be_equivalent_to(expected_xml)
      end
    end
  end
end
