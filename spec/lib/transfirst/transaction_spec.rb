require 'spec_helper'

RSpec.describe Transfirst::Transaction do
  subject {
      customer = Transfirst::Customer.new({
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

      Transfirst::Transaction.new({
        customer: customer,
        wallet: Transfirst::Wallet.new({
          customer: customer,
          card_number: "411111******1111",
          cvv: 123,
          expiry: '1216',
          order_number: 'WalletCustRefID',
          tf_id: 1234567890
        }),
        amount: 4200,
      })
    }
  describe "#perform" do

    it "should make an api request for transaction with details" do
      expected_xmls = %w(tran_code req_amt ind_code recur_man).map do |fname|
        File.read("spec/fixtures/transaction_#{fname}_request.xml")
      end

      api = double(:api)
      subject.api=api
      expect(api).to receive(:make_request).with(:send_tran,
                                                 'SendTranRequest',
                                                 be_equivalent_to(expected_xmls[0]),
                                                 be_equivalent_to(expected_xmls[1]),
                                                 be_equivalent_to(expected_xmls[2]),
                                                 be_equivalent_to(expected_xmls[3]))
                                           .and_return({send_tran_response: {rsp_code: "00", tran_data: {tran_nr: '111111'}}})
      subject.perform
      expect(subject.transaction_id).to eq('111111')
      expect(subject.transaction_meta).to be
      expect(subject.status).to eq(:success)
    end
  end
end
