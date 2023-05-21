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
        content.gsub(/\!\[(.*?)\]\((.*?)\)/, "{%- picture jpt-webp \\2 alt='\\1' -%}")
      end
    end
  end
end

Jekyll::Hooks.register [:pages, :posts, :documents], :pre_render do |doc|
  doc.content = doc.content.gsub(/\!\[(.*?)\]\((.*?)\)/, "{%- picture jpt-webp \\2 --alt '\\1' -%}")
end
