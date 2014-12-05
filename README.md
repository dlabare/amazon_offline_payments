# AmazonOfflinePayments

An extension to ActiveMerchant that provides access to the AmazonOfflinePamyents API

## Installation

Add this line to your application's Gemfile:

    gem 'amazon_offline_payments'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amazon_offline_payments

## Usage

You'll need to start off by getting your seller credentials, you can do that here: https://payments.amazon.com/home

Then you'll need to register to use Amazon MWS: http://docs.developer.amazonservices.com/en_US/dev_guide/DG_Registering.html

Once you have your credentials, you'll need to pass them into your gateway:

    ActiveMerchant::Billing::AmazonOfflinePaymentsGateway.new(:seller_id => 'XXX', :access_key_id => 'YYY', :secret_key => 'ZZZ')

You can also store those credentials the the following ENV variables:

    MWS_SELLER_ID=XXX
    MWS_ACCESS_KEY_ID=YYY
    MWS_SECRET_KEY=ZZZ

And they will automatically be used when creating a new gateway:

    ActiveMerchant::Billing::AmazonOfflinePaymentsGateway.new

If you would like to spit out some additional information about the requests/signatures and responses to and from the API, you may pass a :verbose => true flag to the gateway (helpful for debugging)

    ActiveMerchant::Billing::AmazonOfflinePaymentsGateway.new(:verbose => true)


## Contributing

1. Fork it ( http://github.com/<my-github-username>/amazon_offline_payments/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
