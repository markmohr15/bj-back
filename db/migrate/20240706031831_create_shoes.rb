class CreateShoes < ActiveRecord::Migration[7.1]
  def change
    create_table :shoes do |t|
      t.references :session, null: false, foreign_key: true
      t.text :cards
      
      t.timestamps
    end
  end
end
