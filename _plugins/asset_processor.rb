require 'fileutils'
require 'liquid'
require_relative 'minify_filter.rb'  # Include the minify filter script

module Jekyll
  class AssetProcessor
    include MinifyFilter  # Include the minify filter methods

    def initialize(site)
      raise "Site source not set in asset processor" if site.source.nil?
  
      @site = site
      @source = @site.source + "/_assets/"
      @destination = @site.dest
    end

    def copy
      Dir.glob(@source + "**/*").each do |file|
        next if File.directory?(file)
  
        # Calculate the relative path
        relative_path = file.sub(@source, '')
  
        begin
          minified_content = process(relative_path)
          dest_path = File.join(@destination, relative_path)
  
          FileUtils.mkdir_p(File.dirname(dest_path))
          File.open(dest_path, 'w') do |f|
            f.write(minified_content)  # Write the minified content
          end
        rescue StandardError => e
          Jekyll.logger.error "Error processing assets: #{e.message}"
        end
      end
    end

    def process(input)
      raise "Site source not set in processing filter" if @site.source.nil?

      file = @source + input
      if File.exist?(file)
        # Process the file before copying
        content = File.read(file)

        # Apply some transformations to the content
        # This is where you'd put your processing logic
        processed_content = process_content(content)

        # Get the file extension
        ext = File.extname(file)

        # Minify the content based on its extension
        minify(processed_content, ext)
      else
        raise "File #{file} not found."
      end
    rescue StandardError => e
      Jekyll.logger.error "Error in processing filter: #{e.message}"
      ""
    end

    def process_content(content)
      raise "Site source not set in content processor" if @site.source.nil?

      # Try to encode the content as UTF-8
      content = content.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

      # Check if the content is valid Liquid template
      if content.include?('{{') && content.include?('}}')
        begin
          # Create a Liquid template from the content
          template = Liquid::Template.parse(content)

          # Add 'site' to the Liquid context
          context = { 'site' => @site }.merge(@site.site_payload)
    
          # Render the template with the context data
          processed_content = template.render(context)

          # Remove the front matter
          processed_content = processed_content.gsub(/^---\s*---\s*/, '')

          return processed_content
        rescue Liquid::SyntaxError => e
          Jekyll.logger.error "Content contains {{ and }}, but is not a valid Liquid syntax. Error: #{e.message}"
          return content
        end
      else
        # Return the original content if it's not a valid Liquid template
        return content
      end
    rescue StandardError => e
      Jekyll.logger.error "Error processing content: #{e.message}"
      ""
    end

    def read_file(input)
      raise "Site source not set in the file reader" if @site.source.nil?

      file = @source + input
      if File.exist?(file)
        File.read(file)
      else
        raise "File #{file} not found."
      end
    rescue StandardError => e
      Jekyll.logger.error "Error processing file: #{e.message}"
      ""
    end

    def get_assets()
      raise "Site static_files not set in assets method" if @site.static_files.nil?
      raise "Site data not set in assets method" if @site.data.nil?
      raise "Site data assets not set in assets method" if @site.data.assets.nil?

      # Map over the static_files array, pulling out the 'path' values
      static_files = @site.static_files.map { |file| file['path'] }
      assets = @site.data.assets

      static_files + assets
    rescue StandardError => e
      Jekyll.logger.error "Error processing asset list: #{e.message}"
      []
    end
  end

  module AssetProcessingFilters
    def process(input)
      site = @context.registers[:site]
      asset_processor = AssetProcessor.new(site)
      asset_processor.process(input)
    end

    def read_file(input)
      site = @context.registers[:site]
      asset_processor = AssetProcessor.new(site)
      asset_processor.read_file(input)
    end

    def get_assets
      site = @context.registers[:site]
      asset_processor = AssetProcessor.new(site)
      asset_processor.get_assets
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetProcessingFilters)

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll::AssetProcessor.new(site).copy
end
