class ChangeGameIndexes < ActiveRecord::Migration[5.1]
  def change
    remove_index :games, column: %i[game_code region], unique: true
  end
end
