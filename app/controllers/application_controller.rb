class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def best_deals
    all_games   = Game.includes(:prices).by_game_code
    currencies  = Price.distinct.pluck(:currency).sort

    csv = CSV.generate(headers: true) do |rows|
      rows << %w[Title Country].concat(currencies)

      all_games.each do |_code, games|
        lowest = games.flat_map(&:prices).min_by { |price| price.value.exchange_to('USD') }
        next if lowest.blank?
        rates = currencies.map { |c| lowest.value.exchange_to(c) }
        rows << [game.first.title, ISO3166::Country[lowest.country].translation('en')].concat(rates)
      end
    end

    send_data csv, type: 'text/csv; charset=utf-8; header=present'
  end

  def glossary
    countries   = Price.distinct.pluck(:country).sort
    currencies  = Price.distinct.pluck(:currency).sort

    csv = CSV.generate(headers: true) do |rows|
      rows << ['Countries']
      rows << ['Country code', 'Country name', 'Currency code', 'Currency name']

      countries.each do |code|
        country = ISO3166::Country[code]
        rows << [code, country.translation('en'), country.currency.iso_code, country.currency.name]
      end

      rows << []

      rows << ['Currencies']
      rows << ['Currency code', 'Currency name']
      currencies.each do |code|
        currency = ISO3166::Country.find_country_by_currency(code).currency
        rows << [code, currency.name]
      end
    end

    send_data csv, type: 'text/csv; charset=utf-8; header=present'
  end

  def about
    csv = CSV.generate(headers: true) do |rows|
      rows << ['Page url', 'http://eshop.calyh.re']
      rows << ['Author', 'https://reddit.com/u/Calyhre']
      rows << ['Code', 'https://github.com/Calyhre/eshop-prices']
    end

    send_data csv, type: 'text/csv; charset=utf-8; header=present'
  end
end
