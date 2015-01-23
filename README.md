# Transfirst

[![Circle CI](https://circleci.com/gh/JJCOINCWEBDEV/transfirst.svg?style=svg)](https://circleci.com/gh/JJCOINCWEBDEV/transfirst)
[![Code Climate](https://codeclimate.com/github/JJCOINCWEBDEV/transfirst/badges/gpa.svg)](https://codeclimate.com/github/JJCOINCWEBDEV/transfirst)

This gem adds subscription billing support using the Transfirst API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transfirst'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transfirst

## Usage

To register a new customer do the following.

```
credentials = {gateway_id: ENV['TF_GATEWAY_ID'], registration_key: ENV['TF_REGISTRATION_KEY']}
api = Transfirst::API.new(credentials)

c = Transfirst::Customer.new({
      full_name: "Vagmi Mudumbai",
      phone_number: 3323222323,
      address_line1: "12202 Airport Way",
      address_line2: "Suite 100",
      city: "Broomfield",
      state: "CO",
      zip_code: "80021",
      country: "US",
      email: "test@mail.com",
    })

c.api = api
c.register

w = Transfirst::Wallet.new({
    customer: c,
    card_number: '4485896261017708',
    expiry: '1601',
    order_number: '42'
  })
w.api = api
w.register

rp = Transfirst::RecurringProfile.new({
  amount: 1000,
  start_date: DateTime.now,
  description: "Bronze Plan",
  purchase_order_number: "1341342342",
  customer: c,
  wallet: w
})
rp.api = api
rp.register
```



## Contributing

1. Fork it ( https://github.com/JJCOINCWEBDEV/transfirst/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
