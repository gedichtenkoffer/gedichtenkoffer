require 'fileutils'
require 'liquid'
require_relative 'minify_filter.rb'  # Include the minify filter script

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll::StaticFileCopier.new.copy(site)
end

module Jekyll
  class StaticFileCopier
    include MinifyFilter  # Include the minify filter methods

    def copy(site)
      source = site.source + "/_assets/"
      destination = site.dest

      Dir.glob(source + "**/*").each do |file|
        next if File.directory?(file)

        begin
          # Process the file before copying
          content = File.read(file)

          # Apply some transformations to the content
          # This is where you'd put your processing logic
          processed_content = process_content(content, site)
          
          # Get the file extension
          ext = File.extname(file)

          # Minify the content based on its extension
          minified_content = minify(processed_content, ext)

          dest_path = File.join(destination, file.sub(source, ''))

          FileUtils.mkdir_p(File.dirname(dest_path))
          File.open(dest_path, 'w') do |f|
            f.write(minified_content)  # Write the minified content
          end
        rescue ArgumentError => e
          Jekyll.logger.error "Error processing #{file}: #{e.message}"
        end
      end
    end

    # A simple example of a processing function
    # This function can be modified to suit your needs
    def process_content(content, site)
      # Try to encode the content as UTF-8
      content = content.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

      # Check if the content is valid Liquid template
      if content.include?('{{') && content.include?('}}')
        begin
          # Create a Liquid template from the content
          template = Liquid::Template.parse(content)

          # Render the template with the site's data
          processed_content = template.render(site.site_payload)

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
    end
  end
end
