require_relative "lib/rails_live_reload/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_live_reload"
  spec.version     = RailsLiveReload::VERSION
  spec.authors     = ["Igor Kasyanchuk", "Liubomyr Manastyretskyi"]
  spec.email       = ["igorkasyanchuk@gmail.com", "manastyretskyi@gmail.com"]
  spec.homepage    = "https://github.com/railsjazz/rails_live_reload"
  spec.summary     = "Ruby on Rails Live Reload"
  spec.description = "Ruby on Rails Live Reload with just a single line of code - just add the gem to Gemfile."
  spec.license     = "MIT"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "railties"
  spec.add_dependency "listen"
  spec.add_dependency "websocket-driver"
  spec.add_dependency "nio4r"

  spec.add_development_dependency "wrapped_print"
end
