require 'httparty'
require 'countries'

module Eshop
  class Countries
    include HTTParty

    URL = 'https://api.ec.nintendo.com/v1/price'.freeze
    DEFAULT_PARAMS = {
      lang: 'en',
      ids: '70010000000000',
    }.freeze

    def self.list
      ISO3166::Country.all.map(&:alpha2).map do |country|
        response = get(URL, query: DEFAULT_PARAMS.merge(country: country))
        response.code == 200 ? country : nil
      end.compact
    end
  end
end
