require "administrate/base_dashboard"

class PriceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    game: Field::BelongsTo,
    id: Field::Number,
    nsuid: Field::String,
    country: CountryField,
    status: Field::String,
    value: MoneyField,
    currency: Field::String,
    value_in_cents: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    game
    nsuid
    country
    value
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    game
    nsuid
    country
    status
    value
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    game
    nsuid
    country
    status
    currency
    value_in_cents
  ].freeze

  # Overwrite this method to customize how prices are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(price)
  #   "Price ##{price.id}"
  # end
end
