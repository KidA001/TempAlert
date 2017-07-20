class CreateSubscribers < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribers do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.integer :ideal_temperature
      t.jsonb :subscriptions, null: false, default: {}
      t.string :google_id
      t.string :photo_url

      t.timestamps
    end
    add_index  :subscribers, :subscriptions, using: :gin
    add_index  :subscribers, :google_id
  end
end
