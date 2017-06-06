require 'administrate/field/base'

class MoneyField < Administrate::Field::Base
  def format
    data.format
  end
end
