class CreateSpots < ActiveRecord::Migration[7.1]
  def change
    create_table :spots do |t|
      t.references :user, null: false, foreign_key: true
      t.references :hand, null: false, foreign_key: true
      t.text :player_cards
      t.integer :wager
      t.boolean :split, default: false
      t.boolean :double, default: false
      t.integer :result
      t.integer :profit
      t.boolean :insurance, default: false
      t.integer :spot_number
      
      t.timestamps
    end
  end
end
