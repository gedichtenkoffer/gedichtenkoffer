module Jekyll
  module ImageFilter
    def imagenify(input)
      input.gsub(/\!\[(.*?)\]\((.*?)\)/, "{%- picture jpt-webp \\2 alt='\\1' -%}")
    end
  end
end

Liquid::Template.register_filter(Jekyll::ImageFilter)
