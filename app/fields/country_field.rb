require 'administrate/field/base'

class CountryField < Administrate::Field::Base
  def to_s
    ISO3166::Country[data].unofficial_names.first
  end
end
