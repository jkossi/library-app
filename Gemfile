source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.1.4', '>= 6.1.4.3'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'

gem 'kaminari', '~> 1.2'
gem 'bootsnap', '>= 1.4.4', require: false

group :test do
  gem 'json_expressions', '~> 0.9.0'
end

group :development, :test do
  gem 'factory_bot_rails', '~> 6.2'
  gem 'rspec-rails', '~> 5.0'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
