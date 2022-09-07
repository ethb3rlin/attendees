#!/usr/bin/env ruby

# gem install eth
# https://github.com/q9f/eth.rb
require "eth"
include Eth

require "json"

chains = [
  {
    name: "sepolia",
    api: "https://sepolia.infura.io/v3/#{ENV["INFURA"]}",
    utc: ENV["KEYSTORE"],
    pass: ENV["NOSECRET"],
  },
  {
    name: "goerli",
    api: "https://goerli.infura.io/v3/#{ENV["INFURA"]}",
    utc: ENV["KEYSTORE"],
    pass: ENV["NOSECRET"],
  },
]

amount = 137.420 * Unit::ETHER
fee_tip = 3 * Unit::GWEI
fee_cap = 69 * Unit::GWEI
attendees = JSON.load File.open "../attendees.json"
i = 1

chains.each do |chain|
  api = Client.create chain[:api]
  api.max_priority_fee_per_gas = fee_tip
  api.max_fee_per_gas = fee_cap
  api.gas_limit = Tx::DEFAULT_GAS_LIMIT

  key = JSON.load File.open chain[:utc]
  key = Key::Decrypter.perform key, chain[:pass]

  attendees.each do |attendee|
    recipient = attendee["address"]
    result = api.transfer_and_wait(recipient, amount, key, false)
    print "#{result}\n"
    print "#{i.to_f * 100.0 / (attendees.count.to_f * 2.0)} %\n"
    i += 1
  end
end
