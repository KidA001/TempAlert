class RemoveFieldsOnUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :subscriptions
    remove_column :users, :ideal_temperature
  end
end
