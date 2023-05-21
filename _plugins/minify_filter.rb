require 'uglifier'
require 'cssminify2'
require 'htmlcompressor'
require 'json'

module Jekyll
  module MinifyFilter
    def minify(input, type)
      return "" if input.nil? || !input.is_a?(String)

      case type
      when 'js'
        if input.include?('{{') || input.include?('}}') || input.include?('serviceWorker')
          input
        else
          uglifier = Uglifier.new(harmony: true)
          uglifier.compile(input)
        end
      when 'json'
        JSON.generate(JSON.parse(input))
      when 'css'
        CSSminify2.compress(input)
      when 'html'
        compressor = HtmlCompressor::Compressor.new
        compressor.compress(input)
      else
        input
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::MinifyFilter)
