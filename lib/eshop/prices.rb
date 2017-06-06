require 'active_support/core_ext/array/grouping'
require 'httparty'

module Eshop
  class Prices
    include HTTParty

    URL = 'https://api.ec.nintendo.com/v1/price'.freeze
    DEFAULT_PARAMS = {
      lang: 'en',
    }.freeze

    def self.list(country: 'US', ids: [], limit: 50)
      prices = ids.in_groups_of(limit).flat_map do |ids_to_fetch|
        Rails.logger.debug "Retrieving #{ids_to_fetch.count} prices..."
        query = DEFAULT_PARAMS.merge(country: country, ids: ids_to_fetch.join(','))
        response = get(URL, query: query)
        JSON.parse(response.body, symbolize_names: true)[:prices]
      end
      prices.select! { |p| p && p.include?(:regular_price) }
      prices.map { |price| coerce(price, country) }
    end

    def self.coerce(price, country)
      value = price.dig(:regular_price, :raw_value).to_f
      currency = price.dig(:regular_price, :currency)
      {
        nsuid: price[:title_id],
        country: country,
        status: price[:sales_status],
        currency: price.dig(:regular_price, :currency),
        value_in_cents: Money.from_amount(value, currency).cents,
      }
    end
  end
end
