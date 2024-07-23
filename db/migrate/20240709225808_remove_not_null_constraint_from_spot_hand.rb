class RemoveNotNullConstraintFromSpotHand < ActiveRecord::Migration[7.1]
  def up
    change_column_null :spots, :hand_id, true
  end

  def down
    change_column_null :spots, :hand_id, false
  end
end