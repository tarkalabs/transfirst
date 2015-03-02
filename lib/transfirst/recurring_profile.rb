class Transfirst::RecurringProfile < Transfirst::Base

  DIRECT_MARKETING = 0
  DEBIT = 0
  AT_A_DATE = 51

  FETCH_NODE = 'recurProfCrta'
  FETCH_ID = 'id'

  response_key :id

  attr_accessor :amount, :start_date, :description, :customer, :wallet, :api, :tf_id, :status, :next_charge_date

  def initialize(*args)
    if args.count == 2
      api, attrs = *args

      tf_recurring_profiles_attrs = attrs[:recur_prof]

      if tf_recurring_profiles_attrs.kind_of?(Array)
        tf_recurring_profile_attrs = tf_recurring_profiles_attrs.first[:recur]
      else
        tf_recurring_profile_attrs = tf_recurring_profiles_attrs[:recur]
      end

      @tf_id = attrs[:recur_prof][:recur_prof_id]
      @api = api

      @amount = tf_recurring_profile_attrs[:amt].to_i
      @start_date = tf_recurring_profile_attrs[:start_dt]
      @next_charge_date = tf_recurring_profile_attrs[:next_proc_dt]

      @description = tf_recurring_profile_attrs[:desc]

      @status = tf_recurring_profile_attrs[:recur_prof_stat].to_i
    else
      super(*args)
    end
  end

  def set_up_associations(customer, wallet)
    @customer = customer
    @wallet = wallet
  end

  def active?
    @status == STATUS_ACTIVE
  end

  private

  def xml_for_action(action, status = STATUS_ACTIVE)
    xmlns = Transfirst::API::VERSION
    xsd_path = Transfirst::API::XSD_PATH
    builder = Nokogiri::XML::Builder.new do |xml|
      xml[xmlns].recurProf({"xmlns:#{xmlns}"=>xsd_path}) do

        if action == UPDATE_ENTITY
          xml[xmlns].recurProfId self.tf_id
        end

        xml[xmlns].type action
        xml[xmlns].recur do

          xml[xmlns].recurProfStat status
          xml[xmlns].dbtOrCdt DEBIT # apparently the only valid value as per doc
          xml[xmlns].amt self.amount # should probably be in cents
          xml[xmlns].startDt self.start_date.iso8601
          xml[xmlns].blngCyc AT_A_DATE
          xml[xmlns].desc self.description
          xml[xmlns].custId self.customer.tf_id
          xml[xmlns].pmtId self.wallet.tf_id
          xml[xmlns].ordNr self.wallet.order_number
        end
      end
    end
    builder.to_xml :save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
  end
end
