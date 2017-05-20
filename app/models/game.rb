class Game < ApplicationRecord
  REGIONS = %w(americas europe asia).freeze
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

  scope :order_by_title, -> {
    order('LOWER(title COLLATE "C")')
  }

  scope :order_by_region, -> {
    order_by = ['case']
    REGIONS.each_with_index do |region, index|
      order_by << "WHEN games.region='#{region}' THEN #{index}"
    end
    order_by << 'end'
    order(order_by.join(' '))
  }

  scope :by_game_code,  -> { order_by_title.order_by_region.group_by(&:game_code) }
  scope :by_region,     -> { order_by_title.order_by_region.group_by(&:region) }
end
