# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "jekyll-mentioji/version"

Gem::Specification.new do |s|
  s.name          = "jekyll-mentioji"
  s.version       = JekyllMentioji::VERSION
  s.authors       = ["Ashwin Maroli"]
  s.email         = ["ashmaroli@gmail.com"]
  s.homepage      = "https://github.com/ashmaroli/jekyll-mentioji"
  s.summary       = "Faster version of the 'Jekyll::Mentions + Jekyll::Emoji' combo"

  s.files         = ["lib/jekyll-mentioji.rb"]
  s.license       = "MIT"

  s.add_runtime_dependency "gemoji", "~> 3.0"
  s.add_runtime_dependency "jekyll", "~> 3.5"
  s.add_runtime_dependency "nokogiri", "~> 1.4"

  s.add_development_dependency "cucumber", "~> 3.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rubocop", "~> 0.51.0"
end
