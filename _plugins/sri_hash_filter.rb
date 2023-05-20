require 'openssl'
require 'base64'

module Jekyll
  module SRIHashFilter
    def integrity(input)
      # If input is nil, return an empty string
      return "" if input.nil?

      digest = OpenSSL::Digest::SHA384.new
      hash = Base64.strict_encode64(digest.digest(input))
      "sha384-#{hash}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::SRIHashFilter)
