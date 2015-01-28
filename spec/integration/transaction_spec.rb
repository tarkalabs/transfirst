require 'integration_helper'

describe "Transaction integration test", type: 'integration' do
  before do
    @customer = Transfirst::Customer.new({
      full_name: Faker::Name.name,
      # Ugliness due to an overly concerned validator
      phone_number: Faker::PhoneNumber.cell_phone,
      address_line1: Faker::Address.street_address,
      address_line2: Faker::Address.secondary_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip_code: Faker::Address.zip[0..4], #no zip ranges
      country: "US",
      email: Faker::Internet.email
    })
    @wallet = Transfirst::Wallet.new({
      customer: @customer,
      card_number: VALID_CARDS.sample,
      expiry: Faker::Date.forward(1000).strftime("%y%m"),
      order_number: Faker::Company.ein
    });
    @api = Transfirst::API.new(API_CREDENTIALS)
    @td_report=Transfirst::Reports::TransactionDetail.new(API_CREDENTIALS)
  end
  it "should post a successful transaction" do
    @transaction = Transfirst::Transaction.new({customer: @customer,wallet: @wallet, amount: 81})
    @transaction.api = @api
    res=@transaction.perform
    expect(@transaction.transaction_id).to be
    expect(@transaction.transaction_meta).to be
    expect(@transaction.status).to eq(:success)
    puts "DONT PANIC!!! - sleeping for 42 seconds for transaction to appear in the reports"
    sleep 42
    results=@td_report.get_transactions(2.days.ago,DateTime.now)
    transaction_ids = results.map {|r| r[:tran_nr].to_i}
    expect(transaction_ids).to include(@transaction.transaction_id.to_i)
  end
end
