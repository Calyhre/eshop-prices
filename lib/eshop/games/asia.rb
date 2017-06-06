require 'httparty'
require_relative '../../eshop'
require_relative '../../eshop/prices'

module Eshop
  class Games
    class Asia
      include HTTParty

      URL = 'https://ec.nintendo.com/JP/ja/titles/'.freeze
      JSON_REGEX = /NXSTORE\.titleDetail\.jsonData = ([^;]+);/

      def self.list
        games = []
        guess_new_ids.map do |id|
          response = get(URI.join(URL, id))
          next unless response.code == 200
          games << JSON.parse(response.body.scan(JSON_REGEX).last.first, symbolize_names: true)
        end

        games.compact.map { |g| coerce(g) }
      end

      def self.guess_new_ids
        actual_ids = Game.from_asia.with_nsuid.pluck(:nsuid)
        ids = (FIRST_NSUID..(FIRST_NSUID + 1_500)).map(&:to_s) - actual_ids
        Eshop::Prices.list(country: 'JP', ids: ids).map { |p| p[:nsuid].to_s }
      end

      def self.coerce(game)
        {
          region: 'asia',
          title: game[:formal_name],
          release_date: Date.parse(game[:release_date_on_eshop]),
          nsuid: game[:id],
          cover_url: game[:hero_banner_url],
        }
      end
    end
  end
end
