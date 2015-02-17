class Transfirst::Wallet < Transfirst::Base

  DIRECT_MARKETING = 0

  attr_accessor :customer, :card_number, :cvv, :expiry, :order_number, :api, :tf_id
  response_key :pmt_id

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
            xml[xmlns].xprDt self.expiry
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
