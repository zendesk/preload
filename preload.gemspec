require './lib/preload/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Mick Staugaard']
  gem.email         = ['mick@staugaard.com']
  gem.summary       = 'A better API for ActiveRecord eager loading'
  gem.homepage      = 'https://github.com/zendesk/preload'

  gem.files         = Dir.glob('lib/**/*')
  gem.name          = 'preload'
  gem.version       = Preload::VERSION
  gem.license       = "MIT"

  gem.add_dependency 'activerecord', '>= 5.0', '< 6.2'

  gem.add_development_dependency 'wwtd'
  gem.add_development_dependency 'bump'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'minitest-rg'

  gem.add_development_dependency 'will_paginate'
end
