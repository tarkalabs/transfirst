require 'integration_helper'

describe "Transaction integration test", type: 'integration' do
  before do
    @api = Transfirst::API.new(API_CREDENTIALS)

    @customer = Transfirst::Customer.new({
      full_name: Faker::Name.name,
      phone_number: Faker::PhoneNumber.cell_phone,
      address_line1: Faker::Address.street_address,
      address_line2: Faker::Address.secondary_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip_code: Faker::Address.zip[0..4], #no zip ranges
      country: "US",
      email: Faker::Internet.email,
      api: @api
    })

    @customer.register

    @wallet = Transfirst::Wallet.new({
      customer: @customer,
      card_number: VALID_CARDS.sample,
      cvv: 123,
      expiry: Faker::Date.forward(1000).strftime("%m%y"),
      order_number: Faker::Company.ein,
      api: @api
    })

    @wallet.register
  end

  describe "Transaction Report", type: "slow" do
    it "should post a successful transaction" do
      @transaction = Transfirst::Transaction.new({customer: @customer, wallet: @wallet, amount: 81})
      @transaction.api = @api
      @transaction.perform
      transaction_ids=[]
      3.times do
        puts "waiting for transaction to appear in reports ..."
        sleep 60
        @td_report=Transfirst::Reports::TransactionDetail.new(API_CREDENTIALS)
        results=@td_report.get_transactions(2.days.ago,DateTime.now)
        transaction_ids = results.map {|r| r[:tran_nr].to_i}
        break if transaction_ids.include? @transaction.transaction_id.to_i
      end
      expect(transaction_ids).to include(@transaction.transaction_id.to_i)
    end
  end

  describe "recurring profile" do
    it "should create a transaction" do
      transaction = Transfirst::Transaction.new({customer: @customer, wallet: @wallet, amount: 50})
      transaction.api = @api
      transaction.perform
      expect(transaction.transaction_id).to be
      expect(transaction.transaction_meta).to be
      expect(transaction.status).to eq(:success)
    end

    it "should create a recurring profile" do
      rp = Transfirst::RecurringProfile.new({
        amount: 699,
        start_date: DateTime.now,
        description: "test recurring profile",
        customer: @customer,
        wallet: @wallet
      })

      rp.api = @api
      rp.register
      expect(rp.tf_id).to be
    end
  end
end
