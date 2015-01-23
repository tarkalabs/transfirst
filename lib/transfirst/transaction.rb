class Transfirst::Transaction

  NO_API_ERROR = "No API object configured"
  AUTH_AND_SETTLE = 1
  ECOMMERCE = 2

  include ActiveModel::Model

  attr_accessor :api, :customer, :wallet, :amount
  attr_reader :transaction_id, :transaction_meta, :status

  def perform
    raise NO_API_ERROR unless @api
    res=api.make_request(:send_tran,'SendTranRequest',*xml_for_transaction)
    process(res)
  end

  def process(res)
    if(res[:send_tran_response][:rsp_code]!="00")
      @status=:failed
      raise Transfirst::TransactionError.new(res)
    end
    @transaction_id = res[:send_tran_response][:tran_data][:tran_nr]
    @transaction_meta = res[:send_tran_response]
    @status=:success
  end

  private

  def xml_for_transaction
    [tran_code, card, contact, req_amt, ind_code].map do |n|
      n.to_xml :save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
    end
  end

  def xmlns
    Transfirst::API::VERSION
  end

  def xsd_path
    Transfirst::API::XSD_PATH
  end

  def tran_code
    Nokogiri::XML::Builder.new do |xml|
      xml[xmlns].tranCode({"xmlns:#{xmlns}"=>xsd_path}, AUTH_AND_SETTLE)
    end
  end

  def card
    Nokogiri::XML::Builder.new do |xml|
      xml[xmlns].card({"xmlns:#{xmlns}"=>xsd_path}) do
        xml[xmlns].pan wallet.card_number
        xml[xmlns].xprDt wallet.expiry
      end
    end
  end

  def contact
    Nokogiri::XML::Builder.new do |xml|
      xml[xmlns].contact({"xmlns:#{xmlns}"=>xsd_path}) do
        xml[xmlns].fullName customer.full_name
        xml[xmlns].phone do
          xml[xmlns].type Transfirst::Customer::BUSINESS_PHONE
          xml[xmlns].nr customer.phone_number
        end
        xml[xmlns].addrLn1 customer.address_line1
        xml[xmlns].addrLn2 customer.address_line2
        xml[xmlns].city customer.city
        xml[xmlns].state customer.state
        xml[xmlns].zipCode customer.zip_code
        xml[xmlns].ctry customer.country
        xml[xmlns].email customer.email
      end
    end
  end

  def req_amt
    Nokogiri::XML::Builder.new do |xml|
      xml[xmlns].reqAmt({"xmlns:#{xmlns}"=>xsd_path}, formatted_amount)
    end
  end

  def ind_code
    Nokogiri::XML::Builder.new do |xml|
      xml[xmlns].indCode({"xmlns:#{xmlns}"=>xsd_path}, ECOMMERCE)
    end
  end

  def formatted_amount
    "0" + @amount.to_s
  end
end
