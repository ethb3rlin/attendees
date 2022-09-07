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
  },
  {
    name: "goerli",
    api: "https://goerli.infura.io/v3/#{ENV["INFURA"]}",
  },
]

amount = 137.420 * Unit::ETHER
attendees = JSON.load File.open "../attendees.json"
done = true

chains.each do |chain|
  api = Client.create chain[:api]
  name = chain[:name]
  attendees.each do |attendee|
    recipient = attendee["address"]
    balance = api.get_balance recipient
    if balance < 137420000000000000000
      print "#{name} #{recipient} #{balance}\n"
      done = false
    end
  end
end

if done
  p "all done"
end
