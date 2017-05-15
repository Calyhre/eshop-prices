class DropExchangeRates < ActiveRecord::Migration[5.1]
  def change
    drop_table :exchange_rates
  end
end
