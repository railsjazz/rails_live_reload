require_relative "lib/rails_live_reload/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_live_reload"
  spec.version     = RailsLiveReload::VERSION
  spec.authors     = [""]
  spec.email       = ["igorkasyanchuk@gmail.com"]
  #spec.homepage    = ""
  spec.summary     = "Summary of RailsLiveReload."
  spec.description = "Description of RailsLiveReload."
  spec.license     = "MIT"
  
#  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails"
  spec.add_dependency "listen"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "sprockets-rails"
  spec.add_development_dependency "wrapped_print"
end
