require 'httparty'

module Eshop
  class Games
    class Europe
      include HTTParty

      URL = 'http://search.nintendo-europe.com/en/select'.freeze
      DEFAULT_PARAMS = {
        fl: 'product_code_txt,title,date_from,nsuid_txt,image_url_sq_s',
        fq: [
          'type:GAME',
          "(#{[
            'system_type:"nintendoswitch_gamecard"',
            'system_type:"nintendoswitch_downloadsoftware"',
            'system_type:"nintendoswitch_digitaldistribution"',
          ].join(' OR ')})",
          'product_code_txt:*',
        ].join(' AND '),
        q: '*',
        rows: 9999,
        sort: 'sorting_title asc',
        start: 0,
        wt: 'json',
      }.freeze

      def self.list
        response = get(URL, query: DEFAULT_PARAMS)
        games = JSON.parse(response.body, symbolize_names: true)[:response][:docs]

        games.map { |game| coerce(game) }
      end

      def self.coerce(game)
        {
          region: 'europe',
          game_code: game.dig(:product_code_txt, 0).match(/\AHAC\w?(\w{4})\w\Z/)[1],
          raw_game_code: game.dig(:product_code_txt, 0),
          title: game[:title],
          release_date: Date.parse(game[:date_from]),
          nsuid: game.dig(:nsuid_txt, 0),
          cover_url: game[:image_url_sq_s],
        }
      end
    end
  end
end
