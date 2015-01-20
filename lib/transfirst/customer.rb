require 'transfirst/api'
require 'active_model'

class Transfirst::Customer
  include ActiveModel::Model

  ADD_CUSTOMER = 0
  UPDATE_CUSTOMER = 1
  BUSINESS_PHONE = 3
  RECURRING_PAYMENT = 1
  STATUS_ACTIVE = 1
  NO_API_ERROR = "No API object configured"

  attr_accessor :full_name, :phone_number, :address_line1, :address_line2,
                :city, :state, :zip_code, :country, :email, :tf_id
  attr_accessor :api

  def register
    ensure_api!
    ensure_not_registered!
    res=api.make_request(:updt_recurr_prof,'UpdtRecurrProfRequest',xml_for_action(ADD_CUSTOMER))
    @tf_id = res[:updt_recurr_prof_response][:cust_id]
    self
  end

  def update
    ensure_api!
    ensure_registered!
    res=api.make_request(:updt_recurr_prof,'UpdtRecurrProfRequest',xml_for_action(UPDATE_CUSTOMER))
    self
  end

  private
  def xml_for_action(action)
    xmlns = Transfirst::API::VERSION
    xsd_path = Transfirst::API::XSD_PATH
    builder = Nokogiri::XML::Builder.new do |xml|
      xml[xmlns].cust({"xmlns:#{xmlns}"=>xsd_path}) do
        xml[xmlns].type action
        xml[xmlns].contact do
          xml[xmlns].id self.tf_id if action==UPDATE_CUSTOMER
          xml[xmlns].fullName self.full_name
          xml[xmlns].phone do
            xml[xmlns].type BUSINESS_PHONE
            xml[xmlns].nr self.phone_number
          end
          xml[xmlns].addrLn1 self.address_line1
          xml[xmlns].addrLn2 self.address_line2
          xml[xmlns].city self.city
          xml[xmlns].state self.state
          xml[xmlns].zipCode self.zip_code
          xml[xmlns].ctry self.country
          xml[xmlns].email self.email
          xml[xmlns].type RECURRING_PAYMENT
          xml[xmlns].stat STATUS_ACTIVE
        end
      end
    end
    builder.to_xml :save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
  end
  def ensure_api!
    raise NO_API_ERROR unless @api
  end
  def ensure_not_registered!
    raise "Already Registered" if @tf_id
  end
  def ensure_registered!
    raise "No registration number found" unless @tf_id
  end
end