require 'active_storage/engine'

module Stay
  class Engine < ::Rails::Engine
    isolate_namespace Stay
  end
end
