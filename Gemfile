source 'https://rubygems.org'

# Please see hydra-derivatives.gemspec for dependency information.
gemspec

group :development, :test do
  gem 'byebug' unless ENV['TRAVIS']
  gem 'rubocop', '~> 0.37.2', require: false
  gem 'rubocop-rspec', require: false
end

gem 'active_encode', path: '../active_encode'
gem 'shingoncoder', path: '../shingoncoder'
gem 'rubyhorn', path: '../../avalon/rubyhorn'
gem 'sqlite3'
