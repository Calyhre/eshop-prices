# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

GAME_CSV_FILE = Rails.root.join('db', 'seeds', 'games.csv')

CSV.foreach(GAME_CSV_FILE, headers: true) do |row|
  Game.find_or_create_by(region: row['region'], game_code: row['game_code']).update_attributes(row.to_hash)
end
