module Jekyll
  module AssetsFilter
    def assets(input)
      # Assuming input is the root directory containing your assets
      assets = []
      Dir.glob(File.join(input, '**', '*.{html,css,js,jpeg,jpg,webp,svg}')) do |file|
        # Push relative path to the assets array
        assets << file.sub(input, '')
      end
      assets
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetsFilter)
