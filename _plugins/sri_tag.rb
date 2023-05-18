require 'digest'
require 'base64'

module Jekyll
  module SRITagFilter
    def sri_tag(input)
      file_path = File.join(@context.registers[:site].source, input)
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
