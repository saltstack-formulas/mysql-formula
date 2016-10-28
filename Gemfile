source 'https://rubygems.org'

gem 'codeclimate-test-reporter', group: :test, require: nil
gem 'rake'
gem 'berkshelf', '~> 4.0'

group :integration do
  gem 'test-kitchen'
  gem 'kitchen-salt'
  gem 'kitchen-inspec'
end

group :docker do
  gem 'kitchen-docker'
end

# vi: set ft=ruby :
gem "kitchen-vagrant"
