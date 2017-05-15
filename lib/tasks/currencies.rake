require 'httparty'

API_URL = 'http://rate-exchange-1.appspot.com/currency'.freeze

namespace :currencies do
  desc 'Get all currencies exchange rates'
  task retrieve_all: :environment do
    currencies = Price.pluck(:currency).uniq.sort

    currencies.each do |from|
      puts "Retieving #{currencies.count} rates for #{from} currency..."
      currencies.each do |to|
        response = HTTParty.get(API_URL, query: { from: from, to: to})
        rate = JSON.parse(response.body, symbolize_names: true)[:rate]
        Money.add_rate(from, to, rate)
      end
    end
  end
end
