module Jekyll
  module ImageFilter
    def imagenify(input)
      return "" if input.nil?

      input.gsub(/\!\[(.*?)\]\((.*?)\)/, "{%- picture jpt-webp \\2 alt='\\1' -%}")
    rescue StandardError => e
      Jekyll.logger.error "Error imagenifing #{input}: #{e.message}"
      input
    end
  end
end

Liquid::Template.register_filter(Jekyll::ImageFilter)
