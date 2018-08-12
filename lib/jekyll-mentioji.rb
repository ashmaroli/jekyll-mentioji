# frozen_string_literal: true

require "gemoji"
require "nokogiri"

module Jekyll
  class Mentioji
    MENTIONPATTERNS = %r~(?:^|\B)@((?>[\w][\w-]*))(?!/)(?=\.+[ \t\W]|\.+$|[^\w.]|$)~i

    OPENING_BODY_TAG_REGEX = %r!<body(.*?)>\s*!

    IGNORE_MENTION_PARENTS = %w(pre code a script style).freeze
    IGNORE_EMOJI_PARENTS = %w(pre code tt).freeze

    class << self
      def transform(doc)
        content = doc.output
        return unless content.include?("@") || content.include?(":")
        setup_transformer(doc.site.config)
        doc.output = if content.include?("<body")
                       process_html_body(content)
                     else
                       process(content)
                     end
      end

      def transformable?(doc)
        (doc.is_a?(Jekyll::Page) || doc.write?) &&
          doc.output_ext == ".html" || (doc.permalink&.end_with?("/"))
      end

      private

      def process_html_body(content)
        head, opener, tail  = content.partition(OPENING_BODY_TAG_REGEX)
        body_content, *rest = tail.partition("</body>")

        String.new(head) << opener << process(body_content) << rest.join
      end

      def process(body_content)
        return body_content unless body_content =~ prelim_check_regex
        parsed_body = Nokogiri::HTML::DocumentFragment.parse(body_content)
        parsed_body.search(".//text()").each do |node|
          content = node.text
          next if !content.include?("@") && !content.include?(":")
          node.replace(
            mention_renderer(
              node, emoji_renderer(node, content)
            )
          )
        end
        parsed_body.to_html
      end

      # rubocop:disable Naming/MemoizedInstanceVariableName
      def setup_transformer(config)
        @transconfig ||= {
          "mention_base" => compute_base(
            config, "jekyll-mentions", "base_url", default_mention_base
          ),
          "emoji_source" => compute_base(
            config, "emoji", "src", default_asset_root
          ),
        }
      end
      # rubocop:enable Naming/MemoizedInstanceVariableName

      def compute_base(config, key, subkey, default_value)
        subject = config[key]
        case subject
        when nil, NilClass
          default_value
        when String
          subject
        when Hash
          subject.fetch(subkey, default_value)
        else
          raise TypeError,
            "Your #{key} config has to either be a string or a hash. It's a " \
            "kind of #{subject.class} right now."
        end
      end

      def default_mention_base
        if !ENV["SSL"].to_s.empty? && !ENV["GITHUB_HOSTNAME"].to_s.empty?
          scheme = ENV["SSL"] == "true" ? "https://" : "http://"
          "#{scheme}#{ENV["GITHUB_HOSTNAME"].chomp("/")}"
        else
          "https://github.com"
        end
      end

      def default_asset_root
        if ENV["ASSET_HOST_URL"].to_s.empty?
          File.join("https://assets-cdn.github.com", "/images/icons")
        else
          File.join(ENV["ASSET_HOST_URL"], "/images/icons")
        end
      end

      def mention_markup(username)
        mention_stash[username] ||= begin
          "<a href='#{@transconfig["mention_base"]}/#{username}' " \
          "class='user-mention'>@#{username}</a>"
        end
      end

      def mention_renderer(node, text)
        return text unless text.include?("@")
        return text if has_ancestor?(node, IGNORE_MENTION_PARENTS)
        text.gsub(MENTIONPATTERNS) { mention_markup(Regexp.last_match(1)) }
      end

      def emoji_renderer(node, text)
        return text unless text.include?(":")
        return text if has_ancestor?(node, IGNORE_EMOJI_PARENTS)
        text.gsub(emoji_pattern) { emoji_markup(Regexp.last_match(1)) }
      end

      def emoji_url(name)
        File.join(
          @transconfig["emoji_source"], "emoji", Emoji.find_by_alias(name).image_filename
        )
      end

      def emoji_markup(name)
        emoji_stash[name] ||= begin
          attrs = []
          img_attrs(name).each do |key, value|
            attrs << "#{key}='#{value}'"
          end
          "<img #{attrs.join(" ")}>"
        end
      end

      def img_attrs(name)
        {
          "class"  => "emoji",
          "title"  => ":#{name}:",
          "alt"    => ":#{name}:",
          "src"    => emoji_url(name).to_s,
          "height" => "20",
          "width"  => "20",
        }
      end

      def mention_stash
        @mention_stash ||= {}
      end

      def emoji_stash
        @emoji_stash ||= {}
      end

      def emoji_names
        ::Emoji.all.map(&:aliases).flatten.sort
      end

      def emoji_pattern
        @emoji_pattern ||= %r!:(
          #{emoji_names.map { |name| Regexp.escape(name) }.join('|')}
        ):!x
      end

      def prelim_check_regex
        @prelim_check_regex ||= %r!#{MENTIONPATTERNS}|#{emoji_pattern}!
      end

      # rubocop:disable Naming/PredicateName
      def has_ancestor?(node, tags)
        while (node = node.respond_to?(:parent) && node.parent)
          break true if tags.include?(node.name.downcase)
        end
      end
      # rubocop:enable Naming/PredicateName
    end
  end
end

Jekyll::Hooks.register([:pages, :documents], :post_render) do |doc|
  Jekyll::Mentioji.transform(doc) if Jekyll::Mentioji.transformable?(doc)
end
