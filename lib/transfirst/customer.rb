class Transfirst::Customer < Transfirst::Base

  BUSINESS_PHONE = 3
  RECURRING_PAYMENT = 1
  response_key :cust_id
  attr_accessor :full_name, :phone_number, :address_line1, :address_line2,
                :city, :state, :zip_code, :country, :email, :tf_id
  attr_accessor :api

  private
  def xml_for_action(action, status = STATUS_ACTIVE)
    xmlns = Transfirst::API::VERSION
    xsd_path = Transfirst::API::XSD_PATH
    builder = Nokogiri::XML::Builder.new do |xml|
      xml[xmlns].cust({"xmlns:#{xmlns}"=>xsd_path}) do
        xml[xmlns].type action
        xml[xmlns].contact do

          if action==UPDATE_ENTITY
            xml[xmlns].id self.tf_id
          end

          xml[xmlns].fullName self.full_name

          if self.phone_number
            xml[xmlns].phone do
              xml[xmlns].type BUSINESS_PHONE
              xml[xmlns].nr self.phone_number
            end
          end

          xml[xmlns].addrLn1 self.address_line1
          xml[xmlns].addrLn2 self.address_line2
          xml[xmlns].city self.city
          xml[xmlns].state self.state
          xml[xmlns].zipCode self.zip_code
          xml[xmlns].ctry self.country
          xml[xmlns].email self.email
          xml[xmlns].type RECURRING_PAYMENT
          xml[xmlns].stat status
        end
      end
    end
    builder.to_xml :save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
  end
end
