
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vagrant/terraform/version"

Gem::Specification.new do |spec|
  spec.name          = "vagrant-terraform"
  spec.version       = VagrantPlugins::Terraform::VERSION
  spec.authors       = ["Bob"]
  spec.email         = ["bob2build.2020@gmail.com"]

  spec.summary       = %q{Terraform based Vagrant plugin}
  spec.description   = %q{Terraform based Vagrant plugin}
  spec.homepage      = "https://github.com/bob2build"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fog", "~> 1.22"
  spec.add_runtime_dependency "iniparse", "~> 1.4", ">= 1.4.2"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end