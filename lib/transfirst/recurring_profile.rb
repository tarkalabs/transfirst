class Transfirst::RecurringProfile < Transfirst::Base

  DIRECT_MARKETING = 0
  DEBIT = 0
  AT_A_DATE = 51

  attr_accessor :amount, :start_date, :description, :purchase_order_number,
                :customer, :wallet, :api, :tf_id

  response_key :id

  private

  def xml_for_action(action)
    xmlns = Transfirst::API::VERSION
    xsd_path = Transfirst::API::XSD_PATH
    builder = Nokogiri::XML::Builder.new do |xml|
      xml[xmlns].recurProf({"xmlns:#{xmlns}"=>xsd_path}) do
        xml[xmlns].id self.tf_id if action==UPDATE_ENTITY
        xml[xmlns].type action
        xml[xmlns].recur do
          xml[xmlns].recurProfStat STATUS_ACTIVE
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
