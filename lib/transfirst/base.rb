require 'transfirst/api'
require 'active_model'

class Transfirst::Base
  include ActiveModel::Model

  ADD_ENTITY = 0
  UPDATE_ENTITY = 1
  STATUS_ACTIVE = 1
  STATUS_INACTIVE = 0
  NO_API_ERROR = "No API object configured"
  RECURRING = 1

  def self.inherited(klass)
    class << klass
      attr_accessor :response_id
      def response_key(key)
        @response_id = key
      end
    end
  end

  def register
    ensure_api!
    ensure_not_registered!
    res = api.make_request(:updt_recurr_prof, 'UpdtRecurrProfRequest', xml_for_action(ADD_ENTITY))
    @tf_id = res[:updt_recurr_prof_response][self.class.response_id]
    self
  end

  def update
    ensure_api!
    ensure_registered!
    res = api.make_request(:updt_recurr_prof, 'UpdtRecurrProfRequest', xml_for_action(UPDATE_ENTITY))
    self
  end

  def cancel
    ensure_api!
    ensure_registered!
    res = api.make_request(:updt_recurr_prof, 'UpdtRecurrProfRequest', xml_for_action(UPDATE_ENTITY, STATUS_INACTIVE))
    self
  end

  class << self
    def find_by(tf_id, api)
      res = api.make_request(:fnd_recurr_prof, 'FndRecurrProfRequest', *xml_for_fetch(tf_id))

      customer = Transfirst::Customer.new(api, res[:fnd_recurr_prof_response])
      wallet = Transfirst::Wallet.new(api, res[:fnd_recurr_prof_response])
      recurring_profile = Transfirst::RecurringProfile.new(api, res[:fnd_recurr_prof_response])

      wallet.set_up_associations(customer)
      recurring_profile.set_up_associations(customer, wallet)

      return [customer, wallet, recurring_profile].select {|obj| obj.class == self}.first
    end

    def xml_for_fetch(tf_id)
      xmlns = Transfirst::API::VERSION
      xsd_path = Transfirst::API::XSD_PATH

      namespaces = {
        "xmlns:#{xmlns}" => xsd_path
      }

      builders = []

      builders << Nokogiri::XML::Builder.new do |xml|
        xml[xmlns].type(namespaces, RECURRING)
      end

      builders << Nokogiri::XML::Builder.new do |xml|
        xml[xmlns].send(self::FETCH_NODE, namespaces) do
          xml[xmlns].send(self::FETCH_ID, tf_id)
        end
      end

      builders.map {|builder| builder.to_xml({save_with: Nokogiri::XML::Node::SaveOptions::NO_DECLARATION}) }
    end
  end

  private
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
