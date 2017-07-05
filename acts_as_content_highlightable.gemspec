# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_content_highlightable/version'

Gem::Specification.new do |spec|
  spec.name          = "acts_as_content_highlightable"
  spec.version       = ActsAsContentHighlightable::VERSION
  spec.authors       = ["Karthik Ravichandran"]
  spec.email         = ["kb1990@gmail.com"]
  spec.summary       = %q{One way to highlight HTML content with Rails + Javascript.}
  spec.description   = %q{By tagging all the text nodes in the HTML content, this gem enables highlighting text and saving those highlights with user information}
  spec.homepage      = "https://github.com/kbravi/acts_as_content_highlightable"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pg"
end
