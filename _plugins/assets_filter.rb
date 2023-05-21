module Jekyll
    module AssetsFilter
      def assets(input)
        list = []
        return list if input.nil?
  
        list = []
        Dir.glob(File.join(input, '**', '*.{md,css,js,png,jpeg,jpg,webp,svg}')) do |file|
          path = file.sub(input, '')
          next if File.basename(path).start_with?('.', '_')

          extname = File.extname(path)
          if extname == '.md'
            path = path.gsub(/\.md$/, '.html')
          end

          Jekyll.logger.info "Found asset: #{path}"
          list.push(File.join('/', path))
        end

        list
      end
    end
end

Liquid::Template.register_filter(Jekyll::AssetsFilter)
