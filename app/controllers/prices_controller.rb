class PricesController < ApplicationController
  def index
    @current_page = 'prices'
    @games      = Game.includes(:prices).by_game_code
    @countries  = Price.distinct.pluck(:country).sort
    @currencies = Price.distinct.pluck(:currency).sort
    @currency   = @currencies.include?(params[:currency]) ? params[:currency] : nil

    respond_to do |format|
      format.html
      format.csv { send_data(render_csv, type: 'text/csv; charset=utf-8; header=present') }
    end
  end

  private

  def render_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[Title].concat(@countries)

      @games.each do |_code, games|
        prices = games.flat_map(&:prices)
        csv << [games.first.title] + @countries.map do |country|
          price = prices.detect { |p| p.country == country }
          next 'NA' unless price
          @currency ? price.value.exchange_to(@currency) : price.value
        end
      end
    end
  end
end
