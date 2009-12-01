desc "A task to bootstrap the app environment"
task :bootstrap => [:environment, 'db:schema:load', 'db:test:clone', 'db:seed'] do
  Bootstrapper.bootstrap!
end
