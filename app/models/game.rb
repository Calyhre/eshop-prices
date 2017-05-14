class Game < ApplicationRecord
  REGIONS = %w(americas asia europe)

  attribute :game_code, :string
  attribute :parsed_game_code, :string
  attribute :nsuid, :string
  attribute :region, :string
  attribute :title, :string
  attribute :release_date, :datetime
  attribute :cover_url, :string

  has_many :prices
end
