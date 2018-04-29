# frozen_string_literal: true

require "fileutils"
require "jekyll"
require "safe_yaml/load"

FIXT_DIR = Pathname.new(File.expand_path("fixtures", __dir__))
TEST_DIR = Pathname.new(File.expand_path("../tmp/mentioji", __dir__))
DEFAULT_CONFIG_FILE = TEST_DIR.join("_config.yml")

# -

Before do
  FileUtils.rm_rf(TEST_DIR) if TEST_DIR.exist?
  FileUtils.mkdir_p(TEST_DIR) unless TEST_DIR.directory?
  Dir.chdir(TEST_DIR)
end

# -

After do
  Dir.chdir(TEST_DIR.parent)
end

# -

Given("I have a fixture site") do
  FileUtils.cp_r("#{FIXT_DIR}/.", TEST_DIR)

  if ENV["PLUGINS"]
    config = SafeYAML.load_file(DEFAULT_CONFIG_FILE)
    config["plugins"] = ENV["PLUGINS"].split(":")
    File.write(DEFAULT_CONFIG_FILE, YAML.dump(config))
  end
end

# -

Given("I have a rendered collection named {string}") do |label|
  FileUtils.mkdir_p(TEST_DIR.join("_#{label}"))
  config = SafeYAML.load_file(DEFAULT_CONFIG_FILE)
  config["collections"] ||= {}
  collections_config = config["collections"].merge({
    label => {
      "output" => true,
    },
  })
  config["collections"] = collections_config
  File.write(DEFAULT_CONFIG_FILE, YAML.dump(config))
end

# -

Given("I have an unrendered collection named {string}") do |label|
  FileUtils.mkdir_p(TEST_DIR.join("_#{label}"))
  config = SafeYAML.load_file(DEFAULT_CONFIG_FILE)
  config["collections"] ||= {}
  collections_config = config["collections"].merge({
    label => {
      "output" => false,
    },
  })
  config["collections"] = collections_config
  File.write(DEFAULT_CONFIG_FILE, YAML.dump(config))
end

# -

Given("I have a configuration file with {string} set to {string}") do |key, value|
  config      = SafeYAML.load_file(DEFAULT_CONFIG_FILE)
  config[key] = SafeYAML.load(value)
  Jekyll.set_timezone(value) if key == "timezone"
  File.write(DEFAULT_CONFIG_FILE, YAML.dump(config))
end

# -

Given(%r!I have a (document|page) at "(.*)" with content:!) do |type, path, text|
  content = if type == "page"
              String.new("---\n---\n\n")
            else
              String.new("---\nlayout: default\n---\n\n")
            end
  content << text
  File.open(TEST_DIR.join(path), "wb") { |file| file.puts content }
end

# -

When(%r!^I run jekyll(.*)$!) do |args|
  exe  = Gem.bin_path("jekyll", "jekyll")
  args = args.split(" ")
  @p, _output = Dir.chdir(TEST_DIR) { Jekyll::Utils::Exec.run("ruby", exe, *args) }
end

# -

Then("I should get a zero exit status") do
  expect(@p.exitstatus).to eql(0)
end

# -

Then("I should get a non-zero exit status") do
  expect(@p.exitstatus).to_not eql(0)
end

# -

Then(%r!^the "(.*)" (?:file|directory) should +(not )?exist$!) do |name, negative|
  path = TEST_DIR.join(name)
  if negative.nil?
    expect(Pathname.new(path)).to exist
  else
    expect(Pathname.new(path)).to_not exist
  end
end

# -

Then("I should see {string} in {string}") do |string, path|
  text = File.read(TEST_DIR.join(path))
  expect(text).to include(string)
end

# -

Then("I should not see {string} in {string}") do |string, path|
  text = File.read(TEST_DIR.join(path))
  expect(text).to_not include(string)
end
