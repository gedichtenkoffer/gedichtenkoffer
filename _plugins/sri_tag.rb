require 'digest'
require 'base64'

module Jekyll
  module SRITagFilter
    def sri_tag(input)
      file_path = File.join(@context.registers[:site].dest, input)
      if File.exists?(file_path)
        content = File.read(file_path)
        digest = Digest::SHA384.base64digest(content)
        "sha384-#{digest}"
      else
        nil
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::SRITagFilter)

Jekyll::Hooks.register :site, :post_write do |site|
  site.pages.each do |page|
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
