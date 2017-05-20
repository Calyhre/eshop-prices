class Game < ApplicationRecord
  REGIONS = %w(americas asia europe)

  attribute :game_code, :string
  attribute :region, :string
  attribute :raw_game_code, :string
  attribute :nsuid, :string
  attribute :title, :string
  attribute :release_date, :datetime
  attribute :cover_url, :string

  has_many :prices

  scope :by_title, -> { order('LOWER(title)', :region) }
  scope :by_game_code, -> { by_title.group_by(&:game_code) }
end
