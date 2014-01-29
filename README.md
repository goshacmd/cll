# CLL

CLL-language (Ethereum) simulator. WIP.

## Installation

Add this line to your application's Gemfile:

    gem 'cll'

Or install it yourself as:

    $ gem install cll

## Usage

```ruby
require 'cll'

contract = CLL::Contract.new(balance: 100) do
  push 1
  push "counter"
  sget
  add
  push "counter"
  sset
end

# set('counter', get('counter') + 1)

contract.run_script
puts contract.inspect
```

## Contributing

1. Fork it ( http://github.com/goshakkk/cll/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
