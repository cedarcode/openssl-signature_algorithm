# OpenSSL::SignatureAlgorithm

Signature Algorithm abstraction on top of openssl ruby gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openssl-signature_algorithm'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install openssl-signature_algorithm

## Usage

### ECDSA

```ruby
to_be_signed = "to-be-signed"

# Signer
algorithm = OpenSSL::SignatureAlgorithm::ECDSA.new("256")
signing_key = algorithm.generate_signing_key
signature = algorithm.sign(to_be_signed)

# Signer sends verify key to Verifier
verify_key = signing_key.verify_key

# Verifier
algorithm = OpenSSL::SignatureAlgorithm::ECDSA.new("256")
algorithm.verify_key = verify_key
algorithm.verify(signature, to_be_signed)
```

### RSA-PSS

```ruby
to_be_signed = "to-be-signed"

# Signer
algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("256")
signing_key = algorithm.generate_signing_key
signature = algorithm.sign(to_be_signed)

# Signer sends verify key to Verifier
verify_key = signing_key.verify_key

# Verifier
algorithm = OpenSSL::SignatureAlgorithm::RSAPSS.new("256")
algorithm.verify_key = verify_key
algorithm.verify(signature, to_be_signed)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cedarcode/openssl-signature_algorithm.
