class Transfirst::Reports::TransactionDetail < Transfirst::Reports::Base

  SOAP_ACTION='http://transfirst.com/IeReportsService/GetTransactionDetails'

  attr_accessor :from_date, :to_date, :per_page, :page_number

  def initialize(attrs)
    @page_number = 1
    @per_page = 1
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
    result=make_request(:get_transaction_details,SOAP_ACTION,template.result(get_template_context))
    result[:get_transaction_details_response][:get_transaction_details_result]
  end
  def get_template_context
    context = Object.new
    class << context
      def get_binding
        binding
      end
    end
    b=context.get_binding
    %w(from_date to_date page_number per_page gateway_id registration_key).each do |v|
      b.local_variable_set(v,instance_variable_get("@#{v}"))
    end
    b
  end
  def arrayify(result)
    records=result[:data_record_transaction_details][:data_record_transaction_detail]
    return [] if records.blank?
    return records if records.is_a?(Array)
    [records] if records.is_a?(Hash)
  end

end
