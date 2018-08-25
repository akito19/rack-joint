
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rack/joint/version"

Gem::Specification.new do |spec|
  spec.name          = "rack-joint"
  spec.version       = Rack::Joint::VERSION
  spec.authors       = ["Akito Kasai"]
  spec.email         = ["kasai@akito19.com"]

  spec.summary       = %q{A rack middleware for redirecting.}
  spec.description   = %q{A rack middleware to help you to redirect.}
  spec.homepage      = "https://github.com/akito19/rack-joint"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rack-test"
end
