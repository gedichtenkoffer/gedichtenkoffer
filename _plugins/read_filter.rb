module Jekyll
  module ReadFilter
    def read(input)
      # If input is nil, return an empty string
      return "" if input.nil?
      
      # Read and return file content
      File.read(input)
    rescue StandardError => e
      Jekyll.logger.error "Error reading #{input} file: #{e.message}"
      ""
    end
  end
end

Liquid::Template.register_filter(Jekyll::ReadFilter)
