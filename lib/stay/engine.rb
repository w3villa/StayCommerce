require 'active_storage/engine'

module Stay
  class Engine < ::Rails::Engine
    isolate_namespace Stay

    initializer 'stay.assets.precompile' do |app|
      # Check if the host application is not API-only
      unless app.config.try(:api_only)
       app.config.assets.precompile += %w( stay/application.js stay/application.css )
      end
    end
  end
end
