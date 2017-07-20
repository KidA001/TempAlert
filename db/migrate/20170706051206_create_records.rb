class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.float    :temperature
      t.datetime :recorded_at

      t.timestamps
    end
    add_index :records, :temperature
    add_index :records, :recorded_at
  end
end
