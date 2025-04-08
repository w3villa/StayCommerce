require_relative "lib/stay/version"

Gem::Specification.new do |spec|
  spec.name = "stay_commerce"
  spec.version     = Stay::VERSION
  spec.authors     = [ "w3villa-vikaspal" ]
  spec.email       = [ "vikas.pal@w3villa.com" ]
  spec.homepage    = "https://github.com/w3villa/StayCommerce"
  spec.summary     = "Summary of Stay."
  spec.description = "Description of Stay."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "https://github.com/w3villa/StayCommerce"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/w3villa/StayCommerce"
  spec.metadata["changelog_uri"] = "https://github.com/w3villa/StayCommerce"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.2.1", "< 9.0"
  spec.add_dependency "devise"
  spec.add_dependency "devise-api"
  spec.add_dependency "mysql2", '~> 0.5'
  spec.add_dependency "sassc-rails", '~> 2.1'
  spec.add_dependency "bootstrap", '~> 5.3'
  spec.add_dependency "ransack"
  spec.add_dependency 'activestorage'
  spec.add_development_dependency 'pry'
  spec.add_dependency 'state_machines-activerecord', "~> 0.9"
  spec.add_dependency 'kaminari', '~> 1.2'
  spec.add_dependency 'stripe', '~> 5.32.0'
  spec.add_dependency 'geocoder', "~> 1.8"
  spec.add_dependency 'carmen', '~> 1.1'
  spec.add_dependency 'active_model_serializers'
  spec.add_dependency 'rack-cors', '~> 2.0'
  spec.add_dependency 'paranoia', '~> 3.0'
  spec.add_dependency 'money', '~> 6.12'
  spec.add_dependency 'monetize', '~> 1.13'
  spec.add_dependency 'mobility', '~> 1.2'
  spec.add_dependency 'mobility-ransack', "~> 1.2"
  spec.add_dependency 'inline_svg', '~> 1.10'
  spec.add_dependency 'hotwire-rails', '~> 0.1'
  spec.add_dependency 'jquery-rails', '~> 4.6'
  spec.add_dependency 'jquery-ui-rails', '~> 7.0'
  spec.add_dependency 'jsbundling-rails', '~> 1.3.1'
  spec.add_dependency 'sass-rails', '~> 6.0'
  spec.add_dependency 'sprockets'
  spec.add_dependency 'friendly_id'
  spec.add_development_dependency 'letter_opener', '~> 1.10'
end
