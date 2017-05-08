module CtTableFor
  class Engine < ::Rails::Engine
    isolate_namespace CtTableFor
    paths["app"]

    config.to_prepare do
      ApplicationController.helper(CtTableFor::ApplicationHelper)
    end
  end
end
