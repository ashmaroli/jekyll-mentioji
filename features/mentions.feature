Feature: Mentions
  As a Jekyller who likes to share content with proper attribution
  I want to be able to mention authors and collaborators easily
  And render their handles with proper links

  Scenario: Site with basic configuration
    Given I have a fixture site
    And I have a rendered collection named "docs"
    And I have a document at "_docs/text-n-code.md" with content:
      """
      test @TestUser test

      ```ruby
      def test_output
        "test @codeUser test"
      end
      ```
      user@emailserver.com
      """
    And I have a document at "_docs/underscores-n-dashes.md" with content:
      """
      The quick @brown-fox jumped over the @_lazy_dog sleeping in the barn
      """
    And I have a page at "text.txt" with content:
      """
      {"user": {"name": "@alphabeta", "alias": ":tada:"}}
      """
    And I have a page at "text.json" with content:
      """
      {
        "user": {
          "name"  : "@alphabeta",
          "alias" : ":tada:"
        }
      }
      """
    When I run jekyll build
    Then I should get a zero exit status
    And the "_site" directory should exist
    And I should see '<p>test <a href="https://github.com/TestUser" class="user-mention">@TestUser</a> test</p>' in "_site/docs/text-n-code.html"
    But I should not see '<a href="https://github.com/codeUser" class="user-mention">@TestUser</a>' in "_site/docs/text-n-code.html"
    And I should not see '<a href="https://github.com/emailserver" class="user-mention">@TestUser</a>' in "_site/docs/text-n-code.html"
    But I should see 'test @codeUser test' in "_site/docs/text-n-code.html"
    And I should see '<p>user@emailserver.com</p>' in "_site/docs/text-n-code.html"
    And I should see 'quick <a href="https://github.com/brown-fox" class="user-mention">@brown-fox</a> jumped' in "_site/docs/underscores-n-dashes.html"
    And I should see 'the <a href="https://github.com/_lazy_dog" class="user-mention">@_lazy_dog</a> sleeping' in "_site/docs/underscores-n-dashes.html"
    And I should see '"name": "@alphabeta"' in "_site/text.txt"
    And I should see '"name"  : "@alphabeta"' in "_site/text.json"

  Scenario: Site with custom configuration
    Given I have a fixture site
    And I have a rendered collection named "docs"
    And I have a document at "_docs/text-n-code.md" with content:
      """
      test @TestUser test

      ```ruby
      def test_output
        "test @codeUser test"
      end
      ```
      user@emailserver.com
      """
    And I have a configuration file with "jekyll-mentions" set to "base_url: https://twitter.com"
    When I run jekyll build
    Then I should get a zero exit status
    And the "_site" directory should exist
    And I should not see '<p>test <a href="https://github.com/TestUser" class="user-mention">@TestUser</a> test</p>' in "_site/docs/text-n-code.html"
    But I should see '<p>test <a href="https://twitter.com/TestUser" class="user-mention">@TestUser</a> test</p>' in "_site/docs/text-n-code.html"
