module Jekyll
  module AssetsFilter
    def assets(input, site)
      # If input is nil, return an empty string
      return [] if input.nil?

      # Assuming input is the root directory containing your assets
      assets = []
      Dir.glob(File.join(site.source, input, '**', '*.{html,css,js,jpeg,jpg,webp,svg}')) do |file|
        # Push relative path to the assets array
        assets << file.sub(input, '')
      end
      assets
    rescue StandardError => e
      Jekyll.logger.error "Error asseting input: #{e.message}"
      []
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetsFilter)
