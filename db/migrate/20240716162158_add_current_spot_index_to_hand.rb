class AddCurrentSpotIndexToHand < ActiveRecord::Migration[7.1]
  def change
    add_reference :hands, :current_spot, foreign_key: {to_table: :spots}, null: true
  end
end
