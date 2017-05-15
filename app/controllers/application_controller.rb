class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action do
    request.format = :csv
  end

  def prices
    games     = Game.all.includes(:prices).sort_by(&:title).group_by(&:parsed_game_code)
    countries = Price.pluck(:country).uniq.sort
    currency  = Price.pluck(:currency).include?(params[:currency]) ? params[:currency] : nil

    csv = CSV.generate(headers: true) do |rows|
      rows << %w(title).concat(countries)
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

    respond_to do |format|
      format.csv { send_data csv }
    end
  end

  def rates
    exchange_rates  = ExchangeRate.all
    currencies      = exchange_rates.pluck(:from).uniq.sort

    csv = CSV.generate(headers: true) do |rows|
      rows << [''].concat(currencies)

      currencies.each do |from|
        row = [from]
        currencies.each do |to|
          exchange_rate = exchange_rates.find_by(from: from, to: to)
          row << (exchange_rate.present? ? exchange_rate.rate : 1)
        end
        rows << row
      end
    end

    respond_to do |format|
      format.csv { send_data csv }
    end
  end

  def glossary
    countries   = Price.pluck(:country).uniq.sort
    currencies  = ExchangeRate.pluck(:from).uniq.sort

    csv = CSV.generate(headers: true) do |rows|
      rows << ['Countries']
      rows << ['Country code', 'Country name', 'Currency code', 'Currency name']

      countries.each do |code|
        country = ISO3166::Country[code]
        rows << [code, country.name, country.currency.iso_code, country.currency.name]
      end

      rows << []

      rows << ['Currencies']
      rows << ['Currency code', 'Currency name']
      currencies.each do |code|
        currency = ISO3166::Country.find_country_by_currency(code).currency
        rows << [code, currency.name]
      end

    end

    respond_to do |format|
      format.csv { send_data csv }
    end
  end
end
