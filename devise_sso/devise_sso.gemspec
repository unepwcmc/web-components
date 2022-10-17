$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "devise_sso/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "devise_sso"
  spec.version     = DeviseSso::VERSION
  spec.authors     = ["Will Kocur"]
  spec.email       = [""]
  spec.homepage    = "https://www.github.com/unepwcmc"
  spec.summary     = "Adds devise and configures it for SSO authentication"
  spec.description = "Adds devise and configures it for SSO authentication"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.2.3"
  spec.add_dependency "devise"
  spec.add_dependency "omniauth-azure-activedirectory-v2", "~> 1.0.0"
  spec.add_dependency "omniauth-rails_csrf_protection", "~> 1.0.1"

  spec.add_development_dependency "sqlite3"
end
