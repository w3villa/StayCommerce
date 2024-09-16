module Stay
  class Engine < ::Rails::Engine
    isolate_namespace Stay

    initializer 'stay.assets.precompile' do |app|
      app.config.assets.precompile += %w( stay/application.js stay/application.css )
    end
  end
end
