module Jekyll
  module MarkdownListFilter
    def markdown_list(site)
      list = []
      Dir.glob(File.join(site.source, '**', '*.md')) do |file|
        html_file = file.sub(source, site.destination).sub('.md', '.html')
        # Append the relative path to the array
        list << html_file.sub(site.destination, '')
      end
      list
    rescue StandardError => e
      Jekyll.logger.error "Error listing input: #{e.message}"
      []
    end
  end
end

Liquid::Template.register_filter(Jekyll::MarkdownListFilter)
