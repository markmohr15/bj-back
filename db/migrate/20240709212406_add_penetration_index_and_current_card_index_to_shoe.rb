class AddPenetrationIndexAndCurrentCardIndexToShoe < ActiveRecord::Migration[7.1]
  def change
    add_column :shoes, :penetration_index, :integer
    add_column :shoes, :current_card_index, :integer, default: 0
  end
end
