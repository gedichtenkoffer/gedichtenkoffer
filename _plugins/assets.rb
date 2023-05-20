require 'find'
require 'json'

Jekyll::Hooks.register :site, :post_write do |site|
  assets = []
  Find.find(site.config["destination"]) do |path|
    if FileTest.file?(path) && File.size(path) < 1_048_576
      relative_path = path[site.config["destination"].size..-1]

      # Only include .html, .css, .js, and image files
      if relative_path =~ /\.(html|css|js|jpeg|jpg|webp|svg)$/i
        assets << relative_path
      end
    end
  end
  File.write("#{site.config['destination']}/assets.json", assets.to_json)
end
