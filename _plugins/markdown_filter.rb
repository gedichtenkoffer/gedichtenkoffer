module Jekyll
  module MarkdownListFilter
    def markdown_list(input)
      md_files = []
      Dir.glob(File.join(input, '**', '*.md')) do |file|
        # Replace .md extension with .html and push to the array
        md_files << file.sub(input, '').sub('.md', '.html')
      end
      md_files
    end
  end
end

Liquid::Template.register_filter(Jekyll::MarkdownListFilter)
