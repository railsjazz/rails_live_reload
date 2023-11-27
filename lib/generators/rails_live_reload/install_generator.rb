require 'rails/generators'

module RailsLiveReload
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)

    def copy_initializer
      template "rails_live_reload.rb", "config/initializers/rails_live_reload.rb"
    end
  end
end
