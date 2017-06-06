require 'eshop'

namespace :eshop do
  desc 'Get all games from eShop API'
  task retrieve_games: :environment do
    Eshop::Games.list.map do |raw_game|
      if raw_game[:game_code].present?
        game = Game.where(region: raw_game[:region])
                   .find_or_initialize_by(game_code: raw_game[:game_code])
      elsif raw_game[:nsuid].present?
        game = Game.where(region: raw_game[:region])
                   .find_or_initialize_by(nsuid: raw_game[:nsuid])
      else
        next
      end
      game.update_attributes!(raw_game)
    end
  end

  desc 'Get all prices from eShop API'
  task retrieve_prices: :environment do
    ids = Game.distinct.pluck(:nsuid).compact
    puts "Retrieving #{ids.count} prices..."
    Eshop::COUNTRIES.map do |country|
      printf '  %-20s', ISO3166::Country[country].translation('en')
      prices = Eshop::Prices.list(country: country, ids: ids).map do |price|
        price[:game] = Game.find_by(nsuid: price[:nsuid])
        Price.find_or_initialize_by(nsuid: price[:nsuid], country: country)
             .update_attributes!(price)
      end
      printf ": %-3s\n", prices.count
    end
  end

  desc 'Get all prices from eShop API'
  task retrieve_all: %i[retrieve_games retrieve_prices]

  desc 'Detect new shops that were not selling games before'
  task detect_new_shops: :environment do
    ids = Game.distinct.pluck(:nsuid).compact
    new_shops = []
    puts "Retrieving #{ids.count} prices..."
    countries = Eshop::REGIONS.values.flatten.uniq.sort - Eshop::COUNTRIES
    countries.map do |country|
      printf '  %-20s', ISO3166::Country[country].translation('en')
      prices = Eshop::Prices.list(country: country, ids: ids)
      printf ": %-3s\n", prices.count
      new_shops << country unless prices.empty?
    end

    raise "New shops detected: #{new_shops.join(', ')}" unless new_shops.empty?
  end
end
