# -*- encoding: utf-8 -*-
require File.expand_path('../lib/doubleVision/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tristan Hume"]
  gem.email         = ["tris.hume@gmail.com"]
  gem.description   = %q{Allows you to create magic PNG images that display differently in the browser than in thumbnails.}
  gem.summary       = %q{Generates magic thumbnail images.}
  gem.homepage      = "https://github.com/trishume/doubleVision"

  gem.add_runtime_dependency 'chunky_png'
  gem.post_install_message = "Installed! Now run the 'doubleVision' command to try it out."
  gem.bindir = "bin"
  gem.executables   << 'doubleVision'

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "doubleVision"
  gem.require_paths = ["lib"]
  gem.version       = DoubleVision::VERSION
end
