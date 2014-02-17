source "http://rubygems.org"
source "http://gems.maxcole.com"

# Declare your gem's dependencies in dry_auth.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
#gem "mcp_common", git: 'https://github.com/rjayroach/mcp_common', branch: 'master'

gem 'coveralls', require: false

#gem "devise"
#gem "will_paginate", ">= 3.0.3"
#gem "jquery-datatables-rails"
gem "bootstrap-sass"
group :assets do
  gem "sass-rails"
  gem "coffee-rails"
  gem "uglifier"
  gem "jquery-ui-rails"
  gem "therubyracer", :platform => :ruby
end

group :test do
  gem "timecop"
  gem "spork"
  gem "guard-spork"
  gem "guard-rspec"
  gem "rb-inotify"
  gem "simplecov"
  gem "capybara"
  gem "poltergeist"
  gem "database_cleaner"
  gem "faker"
end

gem "rspec-rails", ">= 2.12.2", :group => [:development, :test]
gem "shoulda-matchers", :group => [:development, :test]
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem "rails3-generators", :group => :development
gem "pry"
gem "pry-rails"
gem "pry-doc", :group => [:development, :test]
gem "pry-nav", :group => [:development, :test]
gem "pry-stack_explorer", :group => [:development, :test]
gem 'commands', group: [:development, :test]
