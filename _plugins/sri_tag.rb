require 'digest'
require 'base64'

module Jekyll
  module SRITagFilter
    @@cache = {}

    def sri_tag(input)
      file_path = File.join(@context.registers[:site].dest, input)

      if File.exists?(file_path)
        file_timestamp = File.mtime(file_path)

        # Check if a hash has been computed and cached for this file,
        # and if the file hasn't been updated since the last computation
        if @context.registers[:site].config["cache_sri"] &&
          @@cache[file_path] && @@cache[file_path][:timestamp] == file_timestamp
          return @@cache[file_path][:digest]
        end

        content = File.read(file_path)
        digest = Digest::SHA384.base64digest(content)

        # Cache the computed hash and the file's timestamp
        if @context.registers[:site].config["cache_sri"]
          @@cache[file_path] = {
            timestamp: file_timestamp,
            digest: "sha384-#{digest}"
          }
        end

        "sha384-#{digest}"
      else
        nil
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::SRITagFilter)

Jekyll::Hooks.register [:pages, :posts, :documents], :pre_render do |doc|
  doc.content = doc.content.gsub(/\{\{\s*(\/.*?\.(css|js|png|svg|ico))\s*\|\s*sri_tag\s*\}\}/) do |match|
    filepath = doc.site.in_source_dir($1.strip)
    if File.exists?(filepath)
      content = File.read(filepath)
      digest = Digest::SHA384.base64digest(content)
      "\"#{filepath}\" integrity=\"sha384-#{digest}\""
    else
      match
    end
  end
end
