$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'junctions/rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'junctions-rails'
  s.version     = Junctions::Rails::VERSION
  s.authors     = ['Paul McKibbin']
  s.email       = ['pmckibbin@gmail.com']
  s.homepage    = 'http://github.com/blackrat/junctions-rails'
  s.summary     = 'Junctions for Rails.'
  s.description = 'Junctions built for ActiveRecord and Rails'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.0'
  s.add_dependency 'junctions', '~> 0.0.5'

  s.add_development_dependency 'simplecov', '~>0'
  s.add_development_dependency 'sqlite3', '~> 1.3'
end
