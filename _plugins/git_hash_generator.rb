module Jekyll
    class GitHashGenerator < Generator
        priority :highest

        def generate(site)
            hash = `git rev-parse HEAD`.strip
            site.config['git_hash'] = hash
        end
    end
end
