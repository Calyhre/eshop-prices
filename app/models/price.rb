class Price < ApplicationRecord
  belongs_to :game

  attribute :nsuid, :string
  attribute :country, :string, limit: 2
  attribute :status, :string
  attribute :currency, :string, limit: 3
  attribute :value_in_cents, :integer

  register_currency :usd
  monetize :value_in_cents, as: 'value', with_model_currency: :currency
end
