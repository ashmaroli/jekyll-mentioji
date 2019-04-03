Feature: Emojis
  As a Jekyller who likes to share content with some adornments
  I want to be able to render emoji graphics easily

  Scenario: Site with basic configuration
    Given I have a fixture site
    And I have a rendered collection named "docs"
    And I have a document at "_docs/text-n-code.md" with content:
      """
      test :tada: test

      ```ruby
      def test_output
        "test :sparkles: test"
      end
      ```
      http:smiley:feed
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
    And I should see '<p>test <img class="emoji" title=":tada:" alt=":tada:" src="https://github.githubassets.com/images/icons/emoji/unicode/1f389.png" height="20" width="20"> test</p>' in "_site/docs/text-n-code.html"
    But I should not see '<img class="emoji" title=":sparkles:" alt=":sparkles:"' in "_site/docs/text-n-code.html"
    But I should see 'test :sparkles: test' in "_site/docs/text-n-code.html"
    And I should see '<p>http<img class="emoji" title=":smiley:" alt=":smiley:" src="https://github.githubassets.com/images/icons/emoji/unicode/1f603.png" height="20" width="20">feed</p>' in "_site/docs/text-n-code.html"
    And I should see '"alias": ":tada:"' in "_site/text.txt"
    And I should see '"alias" : ":tada:"' in "_site/text.json"

  Scenario: Site with custom configuration
    Given I have a fixture site
    And I have a rendered collection named "docs"
    And I have a document at "_docs/text-n-code.md" with content:
      """
      test :tada: test

      ```ruby
      def test_output
        "test :sparkles: test"
      end
      ```
      http:smiley:feed
      """
    And I have a configuration file with "emoji" set to "src: /assets/images/emoji"
    When I run jekyll build
    Then I should get a zero exit status
    And the "_site" directory should exist
    And I should not see '<p>test <img class="emoji" title=":tada:" alt=":tada:" src="https://github.githubassets.com/images/icons/emoji/unicode/1f389.png" height="20" width="20"> test</p>' in "_site/docs/text-n-code.html"
    And I should not see '<img class="emoji" title=":sparkles:" alt=":sparkles:" src="https://github.githubassets.com/images/icons/emoji/unicode/2728.png" height="20" width="20">' in "_site/docs/text-n-code.html"
    And I should not see '<img class="emoji" title=":sparkles:" alt=":sparkles:" src="/assets/images/emoji/emoji/unicode/2728.png" height="20" width="20">' in "_site/docs/text-n-code.html"
    But I should see '<p>test <img class="emoji" title=":tada:" alt=":tada:" src="/assets/images/emoji/emoji/unicode/1f389.png" height="20" width="20"> test</p>' in "_site/docs/text-n-code.html"
    And I should see 'test :sparkles: test' in "_site/docs/text-n-code.html"
