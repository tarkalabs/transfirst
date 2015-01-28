require 'spec_helper'

describe Transfirst::Reports::TransactionDetail do
  subject {
    Transfirst::Reports::TransactionDetail.new({gateway_id: "GATEWAYID", registration_key: "REGISTRATION_KEY"})
  }
  describe "#get_transactions" do
    before do
      @mock_client = double(:soap_client)
      expect(subject).to receive(:soap_client).and_return(@mock_client)
    end
    it "should get a list of transactions" do
      expected_xml = File.read('spec/fixtures/transaction_details_report.xml')
      mock_body = {get_transaction_details_response: {get_transaction_details_result: {data_record_transaction_details: {data_record_transaction_detail: [1,2]},
                                                                                       record_count: 2}}}
      mock_response = double(:response)
      expect(mock_response).to receive(:body).and_return(mock_body)
      expect(@mock_client).to receive(:call).with(:get_transaction_details,
                                                  {soap_action: 'http://transfirst.com/IeReportsService/GetTransactionDetails',
                                                   xml: expected_xml}).and_return(mock_response)
      start_date = DateTime.parse('2015/01/27')
      end_date = DateTime.parse('2015/01/29')
      results=subject.get_transactions(start_date,end_date)
      expect(results).to eq([1,2])
    end
  end
end
