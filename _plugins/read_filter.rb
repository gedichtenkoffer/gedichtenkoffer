module Jekyll
  module ReadFilter
    def read(input, site)
      # If input is nil, return an empty string
      return "" if input.nil?

      source = site['source']
      path = File.join(source, input)
      File.read(path)
    rescue StandardError => e
      Jekyll.logger.error "Error reading file: #{e.message}"
      ""
    end
  end
end

Liquid::Template.register_filter(Jekyll::ReadFilter)
