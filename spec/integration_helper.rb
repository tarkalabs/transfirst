require 'spec_helper'
require 'dotenv'
Dotenv.load
API_CREDENTIALS = {gateway_id: ENV['TF_GATEWAY_ID'], registration_key: ENV['TF_REGISTRATION_KEY']}
VALID_CARDS = ['4485896261017708', '5499740000000057', '38555565010005', '6011000991001201', '371449635392376']
RSpec.configure do |config|
  if API_CREDENTIALS[:gateway_id].blank? or API_CREDENTIALS[:registration_key].blank?
    config.filter_run_excluding type: 'integration'
  end
end
