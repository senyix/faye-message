source "https://rubygems.org"

ruby "2.2.4"

gem "rack"
gem "foreman"
gem "faye"
gem "faye-redis"
gem "puma"

group :development do
  gem "pry"

  # Deployment section
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-bundler', '~> 1.1.4'
  # Add this if you're using rbenv (in the production server)
  gem 'capistrano-rbenv', github: "capistrano/rbenv"
  # Add this if you're using rvm (in the production server)
  # gem 'capistrano-rvm'

  # Other capistrano goodies
  gem 'capistrano-safe-deploy-to', '~> 1.1.1'
end
