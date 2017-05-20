class Game < ApplicationRecord
  REGIONS = %w(americas asia europe).freeze
  GAME_CODE_FORMAT = /\A[0-9A-Z]{4}\z/.freeze
  NSUID_CODE_FORMAT = /\A7001000000[0-9]{4}\z/.freeze

  attribute :game_code,     :string
  attribute :region,        :string
  attribute :raw_game_code, :string
  attribute :nsuid,         :string
  attribute :title,         :string
  attribute :release_date,  :datetime
  attribute :cover_url,     :string

  validates :game_code,   format: { with: GAME_CODE_FORMAT }
  validates :region,      inclusion: { in: REGIONS }
  validates :nsuid,       format: { with: NSUID_CODE_FORMAT }, allow_nil: true

  has_many :prices

  scope :by_title, -> { order('LOWER(title)', :region) }
  scope :by_game_code, -> { by_title.group_by(&:game_code) }
end
