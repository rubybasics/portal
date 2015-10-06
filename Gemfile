source 'https://rubygems.org'
fury_url = ENV['GEMFURY_URL']
source fury_url if fury_url


gem 'rails', '4.1.6'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'

gem 'jsl-identity', '= 0.0.7', require: 'jsl/identity' # for accessing user identities (comes from Gemfury)
gem 'deject'                                           # dependency injection

group :development, :test do
  gem 'rspec-rails', '~> 3.3.0'
  gem 'pry'
  gem 'what_weve_got_here_is_an_error_to_communicate'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'mrspec'
  gem 'jsl-today_json', path: '../today_json'
end
