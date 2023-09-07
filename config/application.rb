require_relative "boot"

# require "rails/all"
require File.expand_path('../boot', __FILE__)

require "rails/all"

require 'pp'

Bundler.require(:default, Rails.env)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    require File.expand_path('../settings', __FILE__)

    config.assets.configure do |env|
      env.export_concurrent = false
    end

    config.filter_parameters += [:password, :password_confirmation, :authenticity_token]
    config.eager_load_paths  += %W(#{config.root}/lib)
    config.eager_load_paths  += Dir[Rails.root.join('app', 'models', '{**}')]

    Rails.autoloaders.main.ignore('lib/tasks', 'lib/assets')

    config.assets.enabled = true

    config.time_zone = 'UTC'

    config.action_dispatch.default_headers = {}
  end
end
