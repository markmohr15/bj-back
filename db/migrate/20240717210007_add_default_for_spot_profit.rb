class AddDefaultForSpotProfit < ActiveRecord::Migration[7.1]
  def up
    change_column :spots, :profit, :integer, default: 0
  end

  def down
    change_column :spots, :profit, :integer, default: nil
  end
end
