module Jekyll
  module ImageFilter
    def imagenify(input)
      # If input is nil, return an empty string
      return "" if input.nil?

      input.gsub(/\!\[(.*?)\]\((.*?)\)/, "{%- picture jpt-webp \\2 alt='\\1' -%}")
    rescue StandardError => e
      Jekyll.logger.error "Error imagenifing #{input}: #{e.message}"
      ""
    end
  end
end

Liquid::Template.register_filter(Jekyll::ImageFilter)
