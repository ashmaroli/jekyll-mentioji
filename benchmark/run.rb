require "bundler/setup"
require "benchmark/ips"
require "jekyll"

def build(*plugins)
  Jekyll::Commands::Build.process(
    "source"      => File.expand_path("fixture", __dir__),
    "destination" => File.expand_path("fixture/_site", __dir__),
    "safe"        => true,
    "quiet"       => true,
    "plugins"     => plugins,
    "whitelist"   => plugins
  )
end

TEMP_FILE = File.expand_path(".benchmark_temp", __dir__)

Benchmark.ips do |x|
  x.time = 15
  x.report("j-mentions + jemoji") { build("jekyll-mentions", "jemoji") }
  x.report("j-mentioji") { build("jekyll-mentioji") }
  x.hold! TEMP_FILE
  x.compare!
end
