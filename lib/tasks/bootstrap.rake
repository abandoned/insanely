desc "A task to bootstrap the app environment"
task :bootstrap => [:environment, 'db:reset'] do
  Bootstrapper.bootstrap!
end
