require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "google/api_client/client_secrets"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TempAlert
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.eager_load_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('app/workers')

    # Attempt to read encrypted secrets from `config/secrets.yml.enc`.
    # Requires an encryption key in `ENV["RAILS_MASTER_KEY"]` or
    # `config/secrets.yml.key`.
    config.read_encrypted_secrets = true

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
