require 'htmlcompressor'
require 'uglifier'
require 'cssminify'

Jekyll::Hooks.register :site, :post_write do |site|
  compressor = HtmlCompressor::Compressor.new
  uglifier = Uglifier.new(harmony: true)

  Dir.glob(File.join(site.dest, '**', '*.{html,css,js}')).each do |file|
    next if File.basename(file).start_with?('.')
    content = File.read(file)

    case File.extname(file)
    when '.html'
      content = compressor.compress(content)
    when '.css'
      content = CSSminify.compress(content)
    when '.js'
      content = uglifier.compile(content)
    end

    File.write(file, content)
  end
end
