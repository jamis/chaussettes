lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chaussettes/version'

Gem::Specification.new do |gem|
  gem.version     = Chaussettes::VERSION
  gem.name        = 'chaussettes'
  gem.authors     = ['Jamis Buck']
  gem.email       = ['jamis@jamisbuck.org']
  gem.homepage    = 'http://github.com/jamis/chaussettes'
  gem.summary     = 'A wrapper around the sox audio manipulation utility'
  gem.description = 'A wrapper around the sox audio manipulation utility'
  gem.license     = 'MIT'

  gem.files         = Dir['{examples,lib}/**/*', 'MIT-LICENSE', 'Rakefile',
                          'README.md']
  gem.test_files    = Dir['test/**/*']
  gem.require_paths = ['lib']

  ##
  # Development dependencies
  #
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
end
