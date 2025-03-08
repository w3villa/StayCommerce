# lib/tasks/install_migrations.rake
namespace :stay_commerce do
  task :install_migrations => :environment do
    migrations_path = File.expand_path("../../db/migrate", __FILE__)
    destination_path = Rails.root.join("db", "migrate")
    FileUtils.cp_r(migrations_path, destination_path) unless Dir.exists?(destination_path)
    puts "Migrations have been installed!"
  end
end