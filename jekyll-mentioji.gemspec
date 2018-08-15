# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "jekyll-mentioji"
  s.version     = "0.1.0"
  s.authors     = ["Ashwin Maroli"]
  s.email       = ["ashmaroli@gmail.com"]
  s.homepage    = "https://github.com/ashmaroli/jekyll-mentioji"
  s.summary     = "Faster version of the 'Jekyll::Mentions + Jekyll::Emoji' combo"
  s.description = "Improve build times for sites using both 'jekyll-mentions and 'jemoji' plugins"

  all_files     = `git ls-files -z`.split("\x0")
  s.files       = all_files.select { |f| f.match(%r!^(lib|LICENSE|README\.md)!) }
  s.license     = "MIT"

  s.required_ruby_version = ">= 2.3.0"

  s.add_runtime_dependency "gemoji", "~> 3.0"
  s.add_runtime_dependency "jekyll", "~> 3.5"
  s.add_runtime_dependency "nokogiri", "~> 1.4"

  s.add_development_dependency "cucumber", "~> 3.0"
  s.add_development_dependency "jekyll-mentions", "~> 1.0"
  s.add_development_dependency "jemoji", "~> 0.9"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rubocop-jekyll", "~> 0.1"
end
