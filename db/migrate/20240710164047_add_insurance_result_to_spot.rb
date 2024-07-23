class AddInsuranceResultToSpot < ActiveRecord::Migration[7.1]
  def change
    add_column :spots, :insurance_result, :integer
  end
end
