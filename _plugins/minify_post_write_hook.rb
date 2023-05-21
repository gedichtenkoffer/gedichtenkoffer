require_relative 'minify_filter.rb'

Jekyll::Hooks.register :site, :post_write do |site|
  include Jekyll::MinifyFilter

  Dir.glob(File.join(site.dest, '**', '*.{html,css,js,json}')).each do |file|
    next if file.nil?
    next if File.basename(file).start_with?('.')
    next if file.start_with?('_')

    if File.exist?(file)
      content = File.read(file)
      ext = File.extname(file).delete_prefix('.')
      
      minified_content = minify(content, ext)
      File.write(file, minified_content)
    else
      raise "File #{file} not found."
    end
  end
end
