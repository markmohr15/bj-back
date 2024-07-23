class AddSessionIdToSpot < ActiveRecord::Migration[7.1]
  def change
    add_reference :spots, :session
  end
end
