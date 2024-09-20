require_relative "lib/stay/version"

Gem::Specification.new do |spec|
  spec.name        = "stay"
  spec.version     = Stay::VERSION
  spec.authors     = [ "w3villa-vikaspal" ]
  spec.email       = [ "vikas.pal@w3villa.com" ]
  spec.homepage    = "https://github.com/w3villa/StayCommerce"
  spec.summary     = "Summary of Stay."
  spec.description = "Description of Stay."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://github.com/w3villa/StayCommerce"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/w3villa/StayCommerce"
  spec.metadata["changelog_uri"] = "https://github.com/w3villa/StayCommerce"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.2.1"
  spec.add_dependency "devise"
  spec.add_dependency "devise-api"
  spec.add_dependency "mysql2"
  spec.add_dependency "sassc-rails"
  spec.add_dependency "bootstrap"
  spec.add_dependency 'activestorage'
  spec.add_development_dependency 'pry'
  spec.add_dependency 'state_machines-activerecord'
  spec.add_dependency 'kaminari', '~> 1.2'
  spec.add_dependency 'geocoder'
end
