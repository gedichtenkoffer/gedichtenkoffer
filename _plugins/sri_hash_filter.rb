require 'openssl'
require 'base64'

module Jekyll
  module SRIHashFilter
    def integrity(input)
      file_path = File.join(@context.registers[:site].dest, input)
      if File.file?(file_path)
        data = File.read(file_path)
        digest = OpenSSL::Digest::SHA384.new
        hash = Base64.strict_encode64(digest.digest(data))
        "sha384-#{hash}"
      else
        raise "File not found: #{input}"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::SRIHashFilter)
