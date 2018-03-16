class RenameSubscribersToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_table :subscribers, :users
  end
end
