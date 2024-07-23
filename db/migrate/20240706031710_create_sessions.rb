class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :decks
      t.integer :penetration
      t.boolean :early_sur, default: false
      t.boolean :late_sur, default: false
      t.boolean :stand_17, default: false
      t.boolean :double_any, default: true
      t.integer :num_spots
      t.boolean :six_five, default: false

      t.timestamps
    end
  end
end
