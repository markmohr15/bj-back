class AddShuffleColumnsToHash < ActiveRecord::Migration[7.1]
  def change
    add_column :shoes, :shuffle_hash, :string
    add_column :shoes, :client_seed, :string
  end
end
