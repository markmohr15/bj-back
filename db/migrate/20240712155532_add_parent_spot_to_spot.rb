class AddParentSpotToSpot < ActiveRecord::Migration[7.1]
  def change
    add_reference :spots, :parent_spot, foreign_key: { to_table: :spots }
    add_index :spots, :split
  end
end
