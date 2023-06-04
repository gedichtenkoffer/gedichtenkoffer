module Jekyll
  module MarkdownImageToPictureTag
    class Converter < Jekyll::Converter
      safe true
      priority :low

      def matches(ext)
        ext =~ /^\.md$/i
      end

      def output_ext(_ext)
        ".html"
      end

      def convert(content)
        content.gsub(/\!\[(.*?)\]\((.*?)\)/) do
          alt_text = $1
          url = $2.gsub('%20', ' ')
          "{%- picture jpt-webp \"#{url}\" alt #{alt_text} -%}"
        end
      end
    end
  end
end

Jekyll::Hooks.register [:pages, :posts, :documents], :pre_render do |doc|
  doc.content = doc.content.gsub(/\!\[(.*?)\]\((.*?)\)/) do
    alt_text = $1
    url = $2.gsub('%20', ' ')
    "{%- picture jpt-webp \"#{url}\" --alt #{alt_text} -%}"
  end
end
