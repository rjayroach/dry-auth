$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dry_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dry_auth"
  s.version     = DryAuth::VERSION
  s.authors     = ["Robert Roach"]
  s.email       = ["rjayroach@gmail.com"]
  s.homepage    = "http://rjayroach.github.io"
  s.summary     = "Simple AAA for a Rails application"
  s.description = "Provide a single authentication interface including Devise, CanCan, Rolify and PaperTrail."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.2.14"
  s.add_dependency "cancan", "~> 1.6.9"
  s.add_dependency "devise", "~> 2.2.3"
  s.add_dependency "rolify", "= 3.3.0.rc3"
  s.add_dependency "omniauth"
  s.add_dependency "omniauth-facebook", '4.0.0'
  s.add_dependency "mcp_common", '>= 0.15.0'

  s.add_development_dependency "sqlite3"
  # s.add_development_dependency "faker"
  s.add_development_dependency "geminabox-rake"
end
