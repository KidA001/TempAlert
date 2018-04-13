require 'webdack/uuid_migration/helpers'

class UuidMigration < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        enable_extension 'pgcrypto'

        primary_key_and_all_references_to_uuid :users
        primary_key_to_uuid :records
        primary_key_to_uuid :subscriptions
      end

      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end
