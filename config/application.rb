require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"

#require 'rails/all'
#require "action_controller/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MiddleWare
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    #config.active_record.raise_in_transactional_callbacks = true

    config.before_configuration do
        env_file = File.join(Rails.root, 'config', 'application.yml')
        if File.exists?(env_file)
            all_config = YAML.load(ERB.new(IO.read(env_file)).result) || {}
            hash = all_config[Rails.env] 
            hash.each do |key, val|
                ENV[key]= val
            end
        end 

        $COMMON_CONST = Hash.new
        common_constants_file = File.join(Rails.root, 'config', 'common_const.yml')
        if File.exists?(common_constants_file)
            all_const = YAML.load(ERB.new(IO.read(common_constants_file)).result) || {}           
            all_const.each do |key, val|
                $COMMON_CONST[key]= val
            end
        end 
    end

    config.middleware.insert_before "ActionDispatch::Static", "Rack::Cors", :debug => true, :logger => Rails.logger do allow do origins '*'
        resource '*',
     :headers => :any,
     :methods => [:get, :post, :delete, :put, :options],
     :max_age => 0

     
 end
end

  end
end
