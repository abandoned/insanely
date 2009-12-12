desc 'Capture bundle of a Heroku app'
task :backup do
  require 'heroku'
  
  app_name    = ENV['APP_NAME']
  bundle_type = ENV['BUNDLE_TYPE'] || 'single'
  credentials = [ENV['HEROKU_LOGIN'], ENV['HEROKU_PASSWORD']]
  
  begin
    heroku = Heroku::Client.new(*credentials)
    
    if bundle_type == 'single'
      heroku.bundles(app_name).each do |bundle|
        heroku.bundle_destroy(app_name, bundle[:name])
      end
      puts 'Destroyed existing bundles'
    end    
    
    heroku.bundle_capture(app_name)
    puts 'Captured new bundle'
  end
end