class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices do |t|
      t.belongs_to :game, foreign_key: true
      t.string :nsuid
      t.string :country, limit: 2
      t.string :status
      t.string :currency, limit: 3
      t.integer :value_in_cents

      t.timestamps
    end

    add_index :prices, [:nsuid, :country], unique: true
  end
end
