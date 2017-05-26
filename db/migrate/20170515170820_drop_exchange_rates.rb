class DropExchangeRates < ActiveRecord::Migration[5.1]
  def change
    drop_table :exchange_rates do |t|
      t.string :from, limit: 3
      t.string :to, limit: 3
      t.float :rate

      t.timestamps
    end
  end
end
