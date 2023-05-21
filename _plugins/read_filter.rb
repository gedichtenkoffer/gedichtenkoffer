module Jekyll
  module ReadFilter
    def read(input)
      return File.nil? if input.nil?

      if File.exist?(input)
        File.read(input)
      else
        raise "File #{input} not found."
      end
    rescue StandardError => e
      Jekyll.logger.error "Error reading file: #{e.message}"
      File.nil?
    end
  end
end

Liquid::Template.register_filter(Jekyll::ReadFilter)
