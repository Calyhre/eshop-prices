class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def prices
    games     = Game.includes(:prices).by_game_code
    countries = Price.distinct.pluck(:country).sort
    currency  = Price.pluck(:currency).include?(params[:currency]) ? params[:currency] : nil

    csv = CSV.generate(headers: true) do |rows|
      rows << %w(Title).concat(countries)
      games.each do |code, games|
        game    = games.first
        prices  = games.flat_map(&:prices)
        row = []
        row << game.title
        countries.each do |country|
          price = prices.detect { |p| p.country === country }
          row << (price ? (currency ? price.value.exchange_to(currency) : price.value) : 'NA')
        end
        # csv << attributes.map{ |attr| user.send(attr) }
        rows << row
      end
    end

    send_data csv, type: 'text/csv; charset=utf-8; header=present'
  end

  def best_deals
    games = Game.includes(:prices).by_game_code
    currencies = Price.distinct.pluck(:currency).sort

    csv = CSV.generate(headers: true) do |rows|
      rows << ['Title', 'Country'].concat(currencies)

      games.each do |code, games|
        game    = games.first
        lowest = games.flat_map(&:prices).min_by { |price| price.value.exchange_to('USD') }
        next if !lowest.present?
        rates = currencies.map { |c| lowest.value.exchange_to(c) }
        rows << [game.title, ISO3166::Country[lowest.country].translation('en')].concat(rates)
      end
    end

    send_data csv, type: 'text/csv; charset=utf-8; header=present'
  end

  def rates
    currencies = Price.distinct.pluck(:currency).sort

    csv = CSV.generate(headers: true) do |rows|
      rows << [''].concat(currencies)

      currencies.each do |from|
        row = [from]
        currencies.each do |to|
          row << Money.default_bank.get_rate(from, to)
        end
        rows << row
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
