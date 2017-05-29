class AddRetireToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :retire, :boolean, default: false
  end
end
