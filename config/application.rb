require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gitban
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.paths.add "lib", eager_load: true
    if Rails.env.development?
      File.open('config/version', 'w') do |file|
        file.write `git describe --tags --always` # or equivalent
      end
    end
    config.version = File.read('config/version')
  end
end
