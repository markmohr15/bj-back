class AddSpotIndexForSpotNumber < ActiveRecord::Migration[7.1]
  def change
    add_index :spots, :spot_number
  end
end
