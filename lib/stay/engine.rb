require 'ransack'
require 'active_storage/engine'
require 'state_machines-activerecord'

require 'stripe'
require 'geocoder'

module Stay
  class Engine < ::Rails::Engine
    isolate_namespace Stay

    initializer 'stay.assets.precompile' do |app|
      app.config.assets.precompile += %w( stay/application.js stay/application.css )
    end

    initializer "stay.load_dependencies" do
      require "devise"
      require "devise/api"
      require "friendly_id"
    end
  
   rake_tasks do
      Dir.glob(File.expand_path("../../tasks/**/*.rake", __dir__)).each { |file| load file }
    end
  end
end
