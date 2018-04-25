source 'https://rubygems.org'
ruby '2.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'responders'
gem 'bcrypt', '~> 3.1.7'
gem 'handlebars_assets'
gem 'fabrication'
gem 'faker'
gem 'sidekiq'
gem 'pg'
gem 'bootstrap-sass'
gem 'figaro'
gem 'stripe'
gem 'stripe_event'
gem 'carrierwave', '~> 1.0'
gem 'carrierwave_direct'
gem 'fog'
gem 'mini_magick'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'jasmine'
  gem 'letter_opener'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'vcr'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'capybara-email'
  gem 'webmock'
  gem 'selenium-webdriver'
end

group :production do
  gem 'rails_12factor'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'backbone-on-rails'
