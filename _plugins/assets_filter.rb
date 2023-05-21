module Jekyll
  module AssetsFilter
    def assets(input)
      list = []
      return list if input.nil?

      Dir.glob(File.join(input, '**', '*.{md,css,js,png,jpeg,jpg,webp,svg}')) do |file|
        path = file.sub(input, '').lstrip

        # Ignore files in the root directory
        next unless path.include?('/')

        # Ignore vendor
        next unless path.include?('/vendor')

        # Ignore stuff that starts with . or _
        next if path.start_with?('.', '_')

        extname = File.extname(path)
        if extname == '.md'
          path = path.gsub(/\.md$/, '.html')
        end

        # Replace all spaces with underscores
        path = path.gsub(' ', '_')

        # Replace multiple consecutive dots with a single dot
        path = path.gsub(/\.{2,}/, '.')
        list.push(File.join('/', path))
      end

      Jekyll.logger.error "No assets found" if list.nil?
      list.push('/index.html')

      list
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetsFilter)
