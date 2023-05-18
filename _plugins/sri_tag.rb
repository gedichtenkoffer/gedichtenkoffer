require 'digest'
require 'base64'

module Jekyll
  module SRITagFilter
    def sri_tag(input)
      file_path = File.join(@context.registers[:site].dest, input)
      if File.exists?(file_path)
        content = File.read(file_path)
        digest = Digest::SHA384.base64digest(content)
        # Jekyll.logger.info "SRI: Hashed #{file_path}"
        "sha384-#{digest}"
      else
        Jekyll.logger.warn "SRI: File not found #{file_path}"
        nil
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::SRITagFilter)

Jekyll::Hooks.register :site, :post_write do |site|
  site.pages.each do |page|
    if page.output
      page.output = page.output.gsub(/integrity="(.*?)"/) do |match|
        path = $1
        if File.exists?(File.join(site.dest, path))
          file_contents = File.read(File.join(site.dest, path))
          digest = Digest::SHA384.base64digest(file_contents)
          'integrity="sha384-' + digest + '"'
        else
          match
        end
      end
    end
  end
end

Jekyll::Hooks.register [:pages, :posts, :documents], :pre_render do |doc|
  doc.content = doc.content.gsub(/\{\{\s*(\/.*?\.(css|js|png|svg|ico))\s*\|\s*sri_tag\s*\}\}/) do |match|
    filepath = doc.site.in_source_dir($1.strip)
    if File.exists?(filepath)
      content = File.read(filepath)
      digest = Digest::SHA384.base64digest(content)
      "\"#{filepath}\" integrity=\"sha384-#{digest}\""
    else
      match
    end
  end
end
