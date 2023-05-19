require 'find'
require 'json'

Jekyll::Hooks.register :site, :post_write do |site|
  assets = []
  Find.find(site.config["destination"]) do |path|
    if FileTest.file?(path) && (!path.end_with?('.png') && File.size(path) < 1_048_576)  # exclude png files and files larger than 1 MB
      path = path[site.source.size..-1]
      assets << path
    end
  end
  File.write("#{site.config['destination']}/assets.json", assets.to_json)
end
