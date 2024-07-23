class AddActiveToShoe < ActiveRecord::Migration[7.1]
  def change
    add_column :shoes, :active, :boolean, default: true
  end
end
