module Jekyll
    module ProcessContentFilter
        def process_content(input)
            return "" if input.nil? || !input.is_a?(String)

            site = @context.registers[:site]
            raise "Site is not set in content processor" if site.nil?

            # Try to encode the content as UTF-8
            content = input.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

            # Check if the content is valid Liquid template
            if content.include?('{{') && content.include?('}}')
                # Create a Liquid template from the content
                template = Liquid::Template.parse(content)
            
                # Render the template with the context data
                processed_content = template.render(@context)

                # Remove the front matter
                processed_content.gsub(/^---\s*---\s*/, '')
            else
                # Return the original content if it's not a valid Liquid template
                content
            end
        rescue Liquid::Error => e
            Jekyll.logger.error "Error processing content: #{e.message}"
            input
        end
    end
end

Liquid::Template.register_filter(Jekyll::ProcessContentFilter)
