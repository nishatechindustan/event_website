require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myappfgfg
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.action_dispatch.default_headers = {
      "Access-Control-Allow-Origin" => "*",
      "Access-Control-Request-Method" => "*",
      "Access-Control-Allow-Methods" => "POST, PUT, DELETE, GET, OPTIONS",
      "Access-Control-Allow-Headers" => "Origin, X-Requested-With, Content-Type, Accept, Authorization",
      "Access-Control-Max-Age" => "1728000",
      "X-Frame-Options" => "http://localhost"
    }
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          methods: %i(get post put patch delete options head)
      end
    end

    config.before_configuration do
      env_file = File.join(Rails.root, '.env')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #config.active_record.raise_in_transactional_callbacks = true
    #config.autoload_paths += ["#{Rails.root.to_s}/lib"]
  end
end
