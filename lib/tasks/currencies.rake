require 'httparty'

API_URL = 'http://api.fixer.io/latest'.freeze

namespace :currencies do
  desc 'Get all currencies exchange rates'
  task retrieve_all: :environment do
    currencies = Price.distinct.pluck(:currency).sort

    currencies.each do |from|
      puts "Retieving #{currencies.count} rates for #{from} currency..."
      response = HTTParty.get(API_URL, query: { base: from, symbols: currencies.join(',') })
      rates = JSON.parse(response.body, symbolize_names: true)[:rates]
      rates.each do |to, rate|
        Money.add_rate(from, to, rate)
      end
      Money.add_rate(from, from, 1.0)
    end
  end
end
