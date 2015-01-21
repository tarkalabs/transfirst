require 'spec_helper'

RSpec.describe Transfirst::TransfirstError do
  it "should format an error message you find a transfirst code" do
    savon_fault = double(:savon_fault)
    err_hash={:fault=>{:faultcode=>"S:Server", :faultstring=>"Service Exception", :detail=>{:system_fault=>{:name=>"Service Exception", :message=>"Service Exception Fault", :error_code=>"50004"}}}}
    expect(savon_fault).to receive(:to_hash).and_return(err_hash)
    error = Transfirst::TransfirstError.new(savon_fault)
    expect(error.message).to eq("Transfirst Service Error -- 50004 - No record found.")
  end
end
