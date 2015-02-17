class Transfirst::Reports::TransactionDetail < Transfirst::Reports::Base

  SOAP_ACTION='http://transfirst.com/IeReportsService/GetTransactionDetails'

  attr_accessor :from_date, :to_date, :per_page, :page_number

  def initialize(attrs)
    @page_number = 1
    @per_page = 100
    super
  end

  def get_transactions(from_date, to_date)
    @from_date = from_date
    @to_date = to_date
    results = []
    result= query_api
    record_count=result[:record_count].to_i
    results.push(*arrayify(result))
    while(record_count > results.count)
      @page_number+=1
      results.push(*arrayify(query_api))
    end
    results
  end

  private

  def template
    template = File.read(File.expand_path(File.join(__FILE__,'../templates/transaction_detail.xml.erb')))
    @template||=ERB.new(template)
  end

  def query_api
    request_body=template.result(binding)
    result=make_request(:get_transaction_details,SOAP_ACTION,request_body)
    result[:get_transaction_details_response][:get_transaction_details_result]
  end

  def arrayify(result)
    if(result[:data_record_transaction_details] and result[:data_record_transaction_details][:data_record_transaction_detail])
      records=result[:data_record_transaction_details][:data_record_transaction_detail]
      return [] if records.blank?
      return records if records.is_a?(Array)
      [records] if records.is_a?(Hash)
    else
      puts result.inspect
      raise "Unable to read response"
    end
  end
end
