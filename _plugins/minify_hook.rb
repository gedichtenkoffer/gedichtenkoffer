require_relative 'minify_filter.rb'

Jekyll::Hooks.register :site, :post_write do |site|
  include Jekyll::MinifyFilter

  Dir.glob(File.join(site.dest, '**', '*.{html,css,js,json}')).each do |file|
    next if file.nil?
    next if File.basename(file).start_with?('.')
    next if file.start_with?('_')
    next if !File.exist?(file)

    content = File.read(file)
    next if content.include?('{{') && content.include?('}}')

    ext = File.extname(file).delete_prefix('.')
    minified_content = minify(content, ext)
    File.write(file, minified_content)
  end
end
