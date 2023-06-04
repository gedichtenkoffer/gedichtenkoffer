module Jekyll
    class UrlCorrector < Generator
      def generate(site)
        site.posts.docs.each do |item|
          item.url = item.url.gsub('_', '%20')
          item.url = item.url.gsub(' ', '%20')
        end
      end
    end
end
