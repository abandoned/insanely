source :gemcutter

gem 'rails', '~> 2.3.5', :require => nil
gem 'compass', '>= 0.8.17'
gem 'haml', '>= 2.2.20'
gem 'erubis', '>= 2.6.5'

gem 'inherited_resources', '1.0.4'
gem 'responders', '0.4.3'
gem 'has_scope', '0.4.2'

gem 'aasm', '>= 2.1.5'
gem 'authlogic', '>= 2.1.3'
gem 'aws-s3', '>= 0.6.2', :require => "aws/s3"
gem 'delayed_job', '>= 1.8.4'
gem 'gravtastic', '>= 2.2.0'
gem 'paperclip', '>= 2.3.1.1'
gem 'RedCloth', '>= 4.2.2'
gem 'will_paginate', '>= 2.3.12'

group :production do
  gem 'pg'
end

group :development do
  gem 'hirb', '>= 0.2.10'
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'annotate'
end

group :test, :cucumber do
  gem 'factory_girl', '>= 1.2.3'
  gem 'rspec', '>=1.3.0', :require => false
  gem 'rspec-rails', '>=1.3.2', :require => false
end

group :cucumber do
  gem 'cucumber', '>=0.6.2', :require => false
  gem 'cucumber-rails', '>=0.2.1', :require => false
  gem 'database_cleaner', '>=0.4.3', :require => false
  gem 'webrat', '>=0.7.0', :require => false
  gem 'pickle', '>= 0.2.1'
end