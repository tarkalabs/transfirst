# Transfirst

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
customer=Transfirst::Customer.register({customer_details})
```



## Contributing

1. Fork it ( https://github.com/[my-github-username]/transfirst/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
