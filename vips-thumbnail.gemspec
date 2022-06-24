# frozen_string_literal: true

require_relative "lib/vips/thumbnail/version"

Gem::Specification.new do |spec|
	spec.name = "vips-thumbnail"
	spec.version = Vips::Thumbnail::VERSION
	
	spec.summary = "Convenient thumbnail resizing using libvips."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/ioquatix/vips-thumbnail"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
	}
	
	spec.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH, base: __dir__)
	
	spec.add_dependency "ruby-vips", "~> 2.1.4"
	
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "covered"
	spec.add_development_dependency "rspec", "~> 3.0"
end
