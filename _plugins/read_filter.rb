module Jekyll
  module ReadFilter
    def read(input, site)
      # If input is nil, return an empty string
      return "" if input.nil?

      # Read and return file content
      path = File.join(site.source, input)
      File.read(path)
    rescue StandardError => e
      Jekyll.logger.error "Error reading input file: #{e.message}"
      ""
    end
  end
end

Liquid::Template.register_filter(Jekyll::ReadFilter)
