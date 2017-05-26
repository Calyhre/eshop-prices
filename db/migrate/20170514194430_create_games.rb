class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :game_code
      t.string :parsed_game_code
      t.string :nsuid
      t.string :region
      t.string :title
      t.datetime :release_date
      t.string :cover_url

      t.timestamps
    end

    add_index :games, %i[game_code nsuid], unique: true
    add_index :games, :parsed_game_code
    add_index :games, :nsuid
  end
end
