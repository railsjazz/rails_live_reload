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

  spec.add_dependency "rails"
  spec.add_dependency "listen"
  spec.add_dependency "faye-websocket"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "sprockets-rails"
  spec.add_development_dependency "wrapped_print"
end
