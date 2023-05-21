require 'openssl'
require 'base64'

module Jekyll
  module SRIHashFilter
    def sri_hash(input)
      return "" if input.nil?

      digest = OpenSSL::Digest::SHA384.new
      hash = Base64.strict_encode64(digest.digest(input))
      "sha384-#{hash}"
    rescue StandardError => e
      Jekyll.logger.error "Error integriting input: #{e.message}"
      input
    end
  end
end

Liquid::Template.register_filter(Jekyll::SRIHashFilter)
