# frozen_string_literal: true

require "fileutils"

SAMPLE_TEXT = <<~TXT
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor libero at
  pharetra :sparkles: tempus. Etiam bibendum:smile:magna et metus fermentum, eu
  cursus lorem mattis. Curabitur vel dui et lacus rutrum suscipit et eget neque.

  Nullam luctus fermentum est id blandit. Phasellus consectetur ullamcorper ligula,
  at finibus eros @ashmaroli laoreet id. Etiam sit amet est in libero efficitur
  tristique. Ut nec magna augue. Quisque ut fringilla lacus, ac dictum enim. Aliquam
  vel ornare mauris. Suspendisse ornare diam tempor nulla facilisis aliquet. Sed
  ultrices placerat ultricies.
  ```ruby
  def test_output
    "test :sparkles: test"
    "test @codeUser test"
  end
  ```
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor libero at
  pharetra tempus. Etiam bibendum magna et metus fermentum, eu cursus lorem mattis.
  Curabitur vel dui et user@emailserver.com lacus rutrum suscipit et eget neque.

  Nullam luctus fermentum est id blandit. Phasellus consectetur ullamcorper ligula, at
  finibus eros laoreet id. Etiam sit @ashmaroli amet est in libero efficitur tristique.
  Ut nec magna :sparkles: augue. Quisque ut fringilla lacus, ac dictum enim. Aliquam
  vel ornare mauris. Suspendisse ornare diam tempor nulla facilisis aliquet. Sed
  ultrices placerat ultricies.
TXT

PLAIN_TEXT = <<~TXT
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor libero at
  pharetra tempus. Etiam bibendum magna et metus fermentum, eu cursus lorem mattis.
  Curabitur vel dui et lacus rutrum suscipit et eget neque.

  Nullam luctus fermentum est id blandit. Phasellus consectetur ullamcorper ligula,
  at finibus eros laoreet id. Etiam sit amet est in libero efficitur tristique.
  Ut nec magna augue. Quisque ut fringilla lacus, ac dictum enim. Aliquam vel ornare
  mauris. Suspendisse ornare diam tempor nulla facilisis aliquet. Sed ultrices
  placerat ultricies.

  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor libero at
  pharetra tempus. Etiam bibendum magna et metus fermentum, eu cursus lorem mattis.
  Curabitur vel dui et lacus rutrum suscipit et eget neque.

  Nullam luctus fermentum est id blandit. Phasellus consectetur ullamcorper ligula,
  at finibus eros laoreet id. Etiam sit amet est in libero efficitur tristique.
  Ut nec magna augue. Quisque ut fringilla lacus, ac dictum enim. Aliquam vel ornare
  mauris. Suspendisse ornare diam tempor nulla facilisis aliquet. Sed ultrices
  placerat ultricies.
TXT

FIXTURE_PAGE_DIR = File.expand_path("fixture/pages", __dir__)
SUCCESS_MESSAGE = "Setup complete!\n\n"

if File.directory?(FIXTURE_PAGE_DIR) && ARGV[0] != "--force"
  puts SUCCESS_MESSAGE
  return
end

FileUtils.rm_rf(FIXTURE_PAGE_DIR)
FileUtils.mkdir_p(FIXTURE_PAGE_DIR)

def create_fixture_files(name, layout, text)
  type = text == SAMPLE_TEXT ? "test" : "base"
  File.open(File.join(FIXTURE_PAGE_DIR, "#{type}-page-#{name}-with-layout-#{layout}.md"), "wb") do |f|
    puts "  Writing: #{f.path.sub(Dir.pwd + '/', '')}"
    content = <<~TEMPL
      ---
      layout: #{layout}
      ---

      #{text}
      TEMPL
    f.puts(content)
  end
end

(1..50).to_a.each do |name|
  create_fixture_files(name, "none", PLAIN_TEXT)
  create_fixture_files(name, "none", SAMPLE_TEXT)
  create_fixture_files(name, "base", SAMPLE_TEXT)
end
puts SUCCESS_MESSAGE
