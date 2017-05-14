class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action do
    request.format = :csv
  end

  def index
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
end
