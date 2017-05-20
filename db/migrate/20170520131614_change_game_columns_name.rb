class ChangeGameColumnsName < ActiveRecord::Migration[5.1]
  def change
    # Undo previous indexes, we are gonna replace them
    remove_index :games, column: [:game_code, :nsuid]
    remove_index :games, column: :parsed_game_code

    # Rename actual columns
    rename_column :games, :game_code, :raw_game_code
    rename_column :games, :parsed_game_code, :game_code

    # Rebuild better indexes
    add_index :games, :game_code
    add_index :games, [:game_code, :region], unique: true
  end
end
