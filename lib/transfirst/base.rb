require 'transfirst/api'
require 'active_model'

class Transfirst::Base
  include ActiveModel::Model

  ADD_ENTITY = 0
  UPDATE_ENTITY = 1
  STATUS_ACTIVE = 1
  STATUS_INACTIVE = 0
  NO_API_ERROR = "No API object configured"

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
