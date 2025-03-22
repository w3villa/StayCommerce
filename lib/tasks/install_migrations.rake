# lib/tasks/install_migrations.rake
namespace :stay_commerce do
  desc "Copy Stay migrations"
  task :install_migrations => :environment do
    migrations_path = File.expand_path("../../db/migrate", __FILE__)
    destination_path = File.expand_path("db/migrate", Rails.root)

    if File.exist?(destination_path)
      FileUtils.cp_r(migrations_path, destination_path)
      puts "Migrations copied to #{destination_path}"
    else
      puts "Migrations directory not found in #{destination_path}"
    end
  end
end