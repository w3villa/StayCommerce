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
  spec.add_dependency "ransack"
  spec.add_dependency 'activestorage'
  spec.add_development_dependency 'pry'
  spec.add_dependency 'state_machines-activerecord'
  spec.add_dependency 'kaminari', '~> 1.2'
  spec.add_dependency 'stripe', '~> 5.32.0'
  spec.add_dependency 'geocoder'
  spec.add_dependency 'carmen'
  spec.add_dependency 'active_model_serializers'
  spec.add_dependency 'rack-cors'
  spec.add_dependency 'paranoia'
  spec.add_dependency 'money'
  spec.add_dependency 'monetize'
  spec.add_dependency 'mobility'
  spec.add_dependency 'mobility-ransack'
  spec.add_dependency 'inline_svg'
  spec.add_dependency 'hotwire-rails'
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'jquery-ui-rails'
  spec.add_dependency 'jsbundling-rails'
  spec.add_dependency 'sass-rails'
  spec.add_dependency 'sprockets'
  spec.add_development_dependency 'letter_opener'
end
