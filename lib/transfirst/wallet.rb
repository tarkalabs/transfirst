class Transfirst::Wallet < Transfirst::Base

  DIRECT_MARKETING = 0

  FETCH_NODE = 'pmtCrta'
  FETCH_ID = 'pmtId'

  response_key :pmt_id

  attr_accessor :customer, :card_number, :cvv, :expiry, :order_number, :api, :tf_id, :status

  def initialize(*args)
    if args.count == 2
      api, attrs = *args
      tf_wallet_attrs = attrs[:cust][:pmt]

      @tf_id = tf_wallet_attrs[:id]
      @api = api

      @card_number = tf_wallet_attrs[:card][:pan]
      @expiry = Transfirst::Wallet.format_expiry(tf_wallet_attrs[:card][:xpr_dt])

      @status = tf_wallet_attrs[:status].to_i

      @order_number = tf_wallet_attrs[:ord_nr]
    else
      super(*args)
    end
  end

  def set_up_associations(customer)
    @customer = customer
  end

  def active?
    @status == STATUS_ACTIVE
  end

  class << self
    # Used to reverse MMYY to YYMM and vice versa for Transfirst reasons
    def format_expiry(expiry_value)
      expiry_value.scan(/../).reverse.join("")
    end
  end

  private

  def xml_for_action(action, status = STATUS_ACTIVE)
    xmlns = Transfirst::API::VERSION
    xsd_path = Transfirst::API::XSD_PATH
    builder = Nokogiri::XML::Builder.new do |xml|
      xml[xmlns].cust({"xmlns:#{xmlns}"=>xsd_path}) do
        xml[xmlns].contact do
          xml[xmlns].id customer.tf_id
        end
        xml[xmlns].pmt do

          if action==UPDATE_ENTITY
            xml[xmlns].id self.tf_id
          end

          xml[xmlns].type action
          xml[xmlns].card do

            # xml[xmlns].type TODO: NEEDS WHAT CLARIFICATION?

            xml[xmlns].pan self.card_number
            xml[xmlns].xprDt Transfirst::Wallet.format_expiry(self.expiry)
          end
          xml[xmlns].ordNr self.order_number
          xml[xmlns].indCode DIRECT_MARKETING
          xml[xmlns].status status
        end
      end
    end
    builder.to_xml :save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
  end
end
