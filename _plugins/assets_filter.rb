module Jekyll
  module AssetsFilter
    def assets(site)
      # Map over the static_files array, pulling out the 'path' values
      static_files = site['static_files'].map { |file| file['path'] }
      assets = site['data']['assets']
      
      static_files + assets
    rescue StandardError => e
      Jekyll.logger.error "Error asseting list: #{e.message}"
      []
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetsFilter)
