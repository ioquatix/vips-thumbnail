# coding: utf-8
require_relative 'lib/vips/thumbnail/version'

Gem::Specification.new do |spec|
	spec.name          = "vips-thumbnail"
	spec.version       = Vips::Thumbnail::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]

	spec.summary       = %q{Convenient thumbnail resizing using libvips.}
	spec.homepage      = "https://github.com/ioquatix/vips-thumbnail"
	
	spec.files         = `git ls-files -z`.split("\x0").reject do |f|
		f.match(%r{^(test|spec|features)/})
	end
	
	spec.require_paths = ["lib"]

	spec.add_dependency "vips", "~> 8.6"

	spec.add_development_dependency "bundler", "~> 1.14"
	spec.add_development_dependency "rake", "~> 10.0"
	spec.add_development_dependency "rspec", "~> 3.0"
end
