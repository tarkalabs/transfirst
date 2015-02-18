require 'spec_helper'

RSpec.describe Transfirst::RecurringProfile do
  subject {
    Transfirst::RecurringProfile.new(
      amount: 100,
      start_date: DateTime.new(2015,1,1),
      description: "desc",
      customer: Transfirst::Customer.new({tf_id: 1315270297974159982}),
      wallet: Transfirst::Wallet.new({
        tf_id: 1315271377706182291,
        order_number: '42'
        })
    )
  }

  xdescribe "::find_by" do
  end

  describe "#initialize" do
    before do
      @attrs = {
        :cust => {
          :contact => {
            :id => "1423699142893170282",
            :full_name => "Gaurav",
            :addr_ln1 => "PO BOX 75152",
            :addr_ln2 => nil,
            :city=>"SEATTLE",
            :state=>"WA",
            :zip_code=>"98175",
            :email=>"cmutukuru@csc.com",
            :type=>"1",
            :stat=>"1"
          },
          :pmt => {
            :id=>"1423699143127131306",
            :card => {
              :pan=>"424242******4242",
              :xpr_dt=>"1907",
              :dbt_or_cdt=>"1"
            },
            :ord_nr=>"1",
            :ind_code=>"0",
            :status=>"1"
          }
        },
        :recur_prof => {
          :recur_prof_id=>"1423699143860111229",
          :recur => {
            :recur_prof_stat=>"1",
            :dbt_or_cdt=>"0",
            :amt=>"81",
            :start_dt=>Time.at(1425196800),
            :blng_cyc=>"51",
            :desc=>"Modus Order",
            :pmt_id=>"1423699143127131306",
            :next_proc_dt=>Time.at(1425196800),
            :nr_of_pmt_proc=>"0",
            :ord_nr=>"1"
          }
        },
        :@xmlns=>"http://postilion/realtime/portal/soa/xsd/Faults/2009/01",
        :"@xmlns:ns2"=>"http://postilion/realtime/merchantframework/xsd/v1/"
      }

      @api = double(:api)
    end

    it "should initialize the recurring_profile with the given attributes" do
      recurring_profile = Transfirst::RecurringProfile.new(@api, @attrs)

      expect(recurring_profile).to be_active
      expect(recurring_profile.tf_id).to eq("1423699143860111229")
      expect(recurring_profile.amount).to eq(81)
      expect(recurring_profile.start_date.to_i).to eq(1425196800)
      expect(recurring_profile.next_charge_date.to_i).to eq(1425196800)
      expect(recurring_profile.description).to eq("Modus Order")
    end
  end

  describe "#xml_for_action" do
    context "register" do
      it "expects xml to be serialized properly" do
        expected_xml=File.read('spec/fixtures/recurring_profile_request.xml')
        actual_xml=subject.send(:xml_for_action,Transfirst::Base::ADD_ENTITY)
        expect(actual_xml).to be_equivalent_to(expected_xml)
      end
    end

    context "update" do
      it "expects xml to be serialized properly" do
        subject.tf_id=1234
        expected_xml=File.read('spec/fixtures/recurring_profile_request_update.xml')
        actual_xml=subject.send(:xml_for_action,Transfirst::Base::UPDATE_ENTITY)
        expect(actual_xml).to be_equivalent_to(expected_xml)
      end
    end
  end
end
