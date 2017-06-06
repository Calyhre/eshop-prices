class GamesController < ApplicationController
  def index
    @current_page = 'games'
    @games = Game.with_game_code.by_game_code
  end
end
