class GamesController < ApplicationController
  def index
    @current_page = 'games'
    @games = Game.by_game_code
  end
end
