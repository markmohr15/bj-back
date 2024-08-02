class ChangeSpotDefaults < ActiveRecord::Migration[7.1]
  def up
    change_column_default :spots, :split, from: false, to: nil
    change_column_default :spots, :double, from: false, to: nil
    change_column_default :spots, :insurance, from: false, to: nil
  end

  def down
    change_column_default :spots, :split, from: nil, to: false
    change_column_default :spots, :double, from: nil, to: false
    change_column_default :spots, :insurance, from: nil, to: false
  end
end
