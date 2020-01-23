# CSR

[![Travis-CI](https://travis-ci.org/fnando/csr.svg)](https://travis-ci.org/fnando/csr)
[![Code Climate](https://codeclimate.com/github/fnando/csr/badges/gpa.svg)](https://codeclimate.com/github/fnando/csr)
[![Test Coverage](https://codeclimate.com/github/fnando/csr/badges/coverage.svg)](https://codeclimate.com/github/fnando/csr/coverage)
[![Gem](https://img.shields.io/gem/v/csr.svg)](https://rubygems.org/gems/csr)
[![Gem](https://img.shields.io/gem/dt/csr.svg)](https://rubygems.org/gems/csr)

Generate CSR (Certificate Signing Request) using Ruby and OpenSSL.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "csr"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csr

## Usage

```ruby
require "csr"

csr = CSR.new(
  country: "US",
  state: "CA",
  city: "San Francisco",
  department: "Web",
  organization: "Example Inc.",
  common_name: "example.com",
  email: "john@example.com"
)

csr.pem
csr.private_key_pem
csr.save_to "/tmp", "server"
#=> creates /tmp/server.csr and /tmp/server.key
```

To use a passphrase on your private key, do it like this:

```ruby
csr = CSR.new(
  country: "US",
  state: "CA",
  city: "San Francisco",
  department: "Web",
  organization: "Example Inc.",
  common_name: "example.com",
  email: "john@example.com",
  passphrase: "sekret"
)
```

You can also verifiy CSR.

```ruby
# If you did not use a passphrase on your private key
CSR.verify?(csr_content, pk_content)

# If you did use a passphrase on your private key
CSR.verify?(csr_content, pk_content, passphrase)
```

To load a CSR back:

```ruby
csr = CSR.load(
  File.read("/tmp/server.csr"),
  passphrase: "sekret",
  private_key: File.read("/tmp/server.key")
)

csr.common_name = "example.com"
```

Notice that `private_key` and `passphrase` are optional when loading CSR; it's
just a shortcut in case you want to regenerate CSR.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git commits
and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/fnando/csr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
