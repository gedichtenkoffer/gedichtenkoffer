require 'uglifier'
require 'cssminify2'
require 'htmlcompressor'

module Jekyll
  module MinifyFilter
    def minify(input, type)
      case type
      when 'js'
        uglifier = Uglifier.new(harmony: true)
        uglifier.compile(input)
      when 'css'
        CSSminify2.compress(input)
      when 'html'
        compressor = HtmlCompressor::Compressor.new
        compressor.compress(input)
      else
        input
      end
    rescue StandardError => e
      puts "Error minifying input: #{e.message}"
      input
    end
  end
end

Liquid::Template.register_filter(Jekyll::MinifyFilter)
