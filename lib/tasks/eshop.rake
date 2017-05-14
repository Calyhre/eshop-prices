require 'eshop'

namespace :eshop do
  desc 'Get all games from eShop API'
  task retrieve_games: :environment do
    Eshop::Games.list.map do |raw_game|
      Game.find_or_create_by(nsuid: raw_game[:nsuid], game_code: raw_game[:game_code]).update_attributes!(raw_game)
    end
  end

  desc 'Get all prices from eShop API'
  task retrieve_prices: :environment do
    Eshop::REGIONS.map do |region, countries|
      ids = Game.where(region: region).pluck(:nsuid)
      puts "Retieving #{ids.count} prices for #{region} with #{countries.count} countries..."
      countries.each do |country|
        print "    #{ISO3166::Country[country]}"
        Eshop::Prices.list(country: country, ids: ids).map do |price|
          price[:game] = Game.find_by(nsuid: price[:nsuid])
          Price.find_or_create_by(nsuid: price[:nsuid], country: country).update_attributes!(price)
        end
        print "  OK\n"
      end
    end
  end

  desc 'Get all prices from eShop API'
  task retrieve_all: [:retrieve_games, :retrieve_prices] do
  end
end
