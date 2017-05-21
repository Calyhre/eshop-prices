require 'active_support/core_ext/array/grouping'
require 'active_support/core_ext/hash/slice'
require 'httparty'
require 'countries'

module Eshop

  # Nintendo split countries this way. So yes, africa and oceania are in europe...
  REGIONS = {
    asia: %w(AE AZ CY HK IN JP KR MY SA SG TR TW),
    europe: %w(AD AL AT AU BA BE BG BW CH CZ DE DJ DK EE ER ES FI FR GB GG GI GR HR HU IE IM IS IT
    JE LI LS LT LU LV MC ME MK ML MR MT MZ NA NE NL NO NZ PL PT RO RS RU SD SE SI SK SM SO SZ TD VA
    ZA ZM ZW),
    americas: %w(AG AI AR AW BB BM BO BR BS BZ CA CL CO CR DM DO EC GD GF GP GT GY HN HT JM KN KY LC
    MQ MS MX NI PA PE PY SR SV TC TT US UY VC VE VG VI),
  }.freeze

  class Countries
    include HTTParty

    URL = 'https://api.ec.nintendo.com/v1/price'.freeze
    DEFAULT_PARAMS = {
      lang: 'en',
      ids: '70010000000000'
    }

    def self.list
      ISO3166::Country.all.map(&:alpha2).map do |country|
        response = get(URL, query: DEFAULT_PARAMS.merge(country: country))
        response.code == 200 ? country : nil
      end.compact
    end
  end

  class Games
    include HTTParty

    def self.list
      list_americas + list_europe
    end

    def self.list_europe
      url = 'http://search.nintendo-europe.com/en/select'
      default_params = {
        fl: 'product_code_txt,title,date_from,nsuid_txt,image_url_sq_s',
        fq: 'type:GAME AND (system_type:"nintendoswitch_gamecard" OR system_type:"nintendoswitch_downloadsoftware" OR system_type:"nintendoswitch_digitaldistribution") AND product_code_txt:*',
        q: '*',
        rows: 9999,
        sort: 'sorting_title asc',
        start: 0,
        wt: 'json'
      }

      response = get(url, query: default_params)
      games = JSON.parse(response.body, symbolize_names: true)[:response][:docs]

      return games.map do |game|
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

    def self.list_asia

    end

    def self.list_americas
      url = 'http://www.nintendo.com/json/content/get/filter/game'
      default_params = {
        limit: 40,
        system: 'switch',
        sort: 'title',
        direction: 'asc',
        shop: 'ncom',
      }.freeze

      response = get(url, query: default_params.merge(limit: 1, offset: 99999))
      games = JSON.parse(response.body, symbolize_names: true)[:games][:game]
      raise 'Nintendo fixed the pagination bug!' if games.count == 1

      # Use this when Nintendo will fix the pagination bug
      # offset  = 0
      # games   = []
      #
      # loop do
      #   response = get(GAMES_URL, query: GAMES_DEFAULT_PARAMS.merge(offset: offset))
      #   offset, new_games, limit = JSON.parse(response.body, symbolize_names: true)[:games].values_at(:offset, :game, :limit)
      #   games = games + new_games
      #   break if new_games.count != limit
      #   offset += limit
      # end
      return games.map do |game|
        next if (game[:game_code] =~ /\AHAC\w?(\w{4})\w\Z/).nil?
        {
          region: 'americas',
          game_code: game[:game_code].match(/\AHAC\w?(\w{4})\w\Z/)[1],
          raw_game_code: game[:game_code],
          title: game[:title],
          release_date: Date.parse(game[:release_date]),
          nsuid: game[:nsuid],
          cover_url: game[:front_box_art],
        }
      end.compact
    end
  end

  class Prices
    include HTTParty

    URL = 'https://api.ec.nintendo.com/v1/price'.freeze
    DEFAULT_PARAMS = {
      lang: 'en',
    }.freeze

    def self.list(country: 'US', ids: [], limit: 50)
      ids.in_groups_of(limit).flat_map do |ids_to_fetch|
        response = get(URL, query: DEFAULT_PARAMS.merge(country: country, ids: ids_to_fetch.join(',')))
        JSON.parse(response.body, symbolize_names: true)[:prices].select { |p| p.include? :regular_price }
      end.map do |price|
        {
          nsuid: price[:title_id],
          country: country,
          status: price[:sales_status],
          currency: price.dig(:regular_price, :currency),
          value_in_cents: Money.from_amount(price.dig(:regular_price, :raw_value).to_f, price.dig(:regular_price, :currency)).cents,
        }
      end
    end
  end
end
