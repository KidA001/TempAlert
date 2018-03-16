class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :type, null: false
      t.boolean :sms_enabled, null: false
      t.boolean :email_enabled, null: false
      t.jsonb :metadata, null: false, default: {}
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
