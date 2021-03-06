# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "jekyll/posseify/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::POSSEify::VERSION
  spec.homepage = "https://nhoizey.github.io/jekyll-posseify/"
  spec.authors = ["Nicolas Hoizey"]
  spec.email = ["nicolas@hoizey.com"]
  spec.files = %w(Rakefile Gemfile README.md RELEASES.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "A Jekyll plugin that generates multiple Atom feeds for POSSE"
  spec.name = "jekyll-posseify"
  spec.license = "MIT"
  spec.require_paths = ["lib"]
  spec.description = <<-DESC
    This Jekyll plugin generates Atom feeds to copy content from your own site to other platforms, following IndieWeb's POSSE principle.
  DESC

  spec.add_runtime_dependency "jekyll", "~> 3.6"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rubocop", "~> 0.55.0"
end
