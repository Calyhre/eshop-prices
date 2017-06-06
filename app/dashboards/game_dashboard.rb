require 'administrate/base_dashboard'

class GameDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    prices: Field::HasMany.with_options(
      limit: 50
    ),
    id: Field::Number,
    raw_game_code: Field::String,
    game_code: Field::String,
    nsuid: Field::String,
    region: Field::Select.with_options(
      collection: %w[americas asia europe]
    ),
    title: Field::String,
    release_date: Field::DateTime,
    cover_url: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    title
    game_code
    region
    nsuid
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    raw_game_code
    game_code
    nsuid
    region
    title
    release_date
    cover_url
    prices
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    raw_game_code
    game_code
    nsuid
    region
    title
    release_date
    cover_url
  ].freeze

  # Overwrite this method to customize how games are displayed
  # across all pages of the admin dashboard.

  def display_resource(game)
    game.title
  end
end
