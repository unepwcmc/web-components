module WcmcComponents
  mattr_accessor :routes_classes

  class Engine < ::Rails::Engine
    isolate_namespace WcmcComponents
  end
end
