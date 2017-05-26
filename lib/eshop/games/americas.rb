require 'httparty'

module Eshop
  class Games
    class Americas
      include HTTParty

      URL = 'http://www.nintendo.com/json/content/get/filter/game'.freeze
      DEFAULT_PARAMS = {
        limit: 40,
        system: 'switch',
        sort: 'title',
        direction: 'asc',
        shop: 'ncom',
      }.freeze

      def self.list
        response = get(URL, query: DEFAULT_PARAMS.merge(limit: 1, offset: 99_999))
        games = JSON.parse(response.body, symbolize_names: true)[:games][:game]
        raise 'Nintendo fixed the pagination bug!' if games.count == 1

        games.map do |game|
          next if (game[:game_code] =~ /\AHAC\w?(\w{4})\w\Z/).nil?
          coerce(game)
        end.compact
      end

      def self.coerce(game)
        {
          region: 'americas',
          game_code: game[:game_code].match(/\AHAC\w?(\w{4})\w\Z/)[1],
          raw_game_code: game[:game_code],
          title: game[:title],
          release_date: Date.parse(game[:release_date]),
          nsuid: game[:nsuid],
          cover_url: game[:front_box_art],
        }
      end
    end
  end
end
