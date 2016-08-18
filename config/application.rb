require_relative 'boot'

require 'rails/all'
require 'elasticsearch/rails/instrumentation'
# require 'elasticsearch/rails/lograge'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SputnikTask
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.assets.enabled = false

    config.generators do |g|
      g.assets false
    end

    # config.lograge.enabled = true
  end
end
