module Jekyll
    module SourcePathFilter
        def source_path(input)
            source = @context.registers[:site].config['source']
            File.join(source, input)
        end
    end
end

Liquid::Template.register_filter(Jekyll::SourcePathFilter)
