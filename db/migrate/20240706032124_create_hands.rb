class CreateHands < ActiveRecord::Migration[7.1]
  def change
    create_table :hands do |t|
      t.references :shoe, null: false, foreign_key: true
      t.text :dealer_cards

      t.timestamps
    end
  end
end
