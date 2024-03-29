$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'wcmc_components/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'wcmc_components'
  spec.version     = WcmcComponents::VERSION
  spec.authors     = ['Ben Tregenna']
  spec.email       = ['']
  spec.homepage    = 'https://www.github.com/unepwcmc'
  spec.summary     = 'Summary of reusable components for UNEP-WCMC projects'
  spec.description = (
    'Contains rudimentary capabilites for importing CSVs and the backend for a filterable table component'
  )
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '>= 5.2.3'

  spec.add_development_dependency 'sqlite3'
end
