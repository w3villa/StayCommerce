require 'ransack'
require 'active_storage/engine'
require 'state_machines-activerecord'

require 'stripe'
module Stay
  class Engine < ::Rails::Engine
    isolate_namespace Stay

    initializer 'stay.assets.precompile' do |app|
      app.config.assets.precompile += %w( stay/application.js stay/application.css )
    end

    @preferences = {}

    class << self
      attr_reader :preferences

      def add_preference(name, type, options = {})
        preferences[name] = { type: type, options: options }
      end
    end

    initializer 'stay.assets.precompile' do |app|
      app.config.assets.precompile += %w( stay/application.js stay/application.css )
    end

    config.to_prepare do
      Stay::Engine.add_preference :storefront_taxons_path, :string, default: 't'
    end
  end
end
