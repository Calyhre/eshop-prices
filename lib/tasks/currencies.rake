require 'httparty'

API_URL = 'http://rate-exchange-1.appspot.com/currency'.freeze

namespace :currencies do
  desc 'Get all currencies exchange rates'
  task retrieve_all: :environment do
    currencies = Price.pluck(:currency).uniq

    currencies.each do |from|
      (currencies - [from]).each do |to|
        response = HTTParty.get(API_URL, query: { from: from, to: to})
        rate = JSON.parse(response.body, symbolize_names: true)[:rate]
        ExchangeRate.find_or_create_by(from: from, to: to).update_attribute(:rate, rate)
      end
    end
  end
end
