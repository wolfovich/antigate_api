# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'antigate_api/version'

Gem::Specification.new do |gem|
  gem.name          = "antigate_api"
  gem.version       = AntigateApi::VERSION
  gem.authors       = ["Tam Vo"]
  gem.email         = ["vo.mita.ov@gmail.com"]
  gem.description   = %q{Antigate (Decode captcha service) wrapper for Ruby}
  gem.summary       = %q{Antigate (Decode captcha service) wrapper for Ruby}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end

