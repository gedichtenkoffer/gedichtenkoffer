module Jekyll
  module AssetsFilter
    def assets(site)
      parsed_source = JSON.parse(site_source)

      # Map over the static_files array, pulling out the 'path' values
      static_files = parsed_source[site.source.static_files].map { |file| file['path'] }
      assets = parsed_source[site.source.data.assets]
      list = static_files + assets

      list
    rescue StandardError => e
      Jekyll.logger.error "Error asseting list: #{e.message}"
      []
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetsFilter)
