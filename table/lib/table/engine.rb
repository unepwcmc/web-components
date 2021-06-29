module Table
  mattr_accessor :routes_classes

  class Engine < ::Rails::Engine
    isolate_namespace Table

  end
end
