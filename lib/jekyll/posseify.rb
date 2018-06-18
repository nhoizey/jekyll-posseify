# frozen_string_literal: true

module Jekyll
  class AtomFeed < StaticFile
    def initialize(site, base, dir, name, content)
      @site = site
      @base = base
      @dir = dir
      @name = name
      @content = content
    end

    def write(dest)
      File.open(destination(dest), "w") { |f| f.write(@content) }
    end
  end

  class AtomGenerator < Generator
    priority :low
    safe true

    def generate(site)
      require 'rss'
      require 'cgi/util'

      rss = RSS::Maker.make("atom") do |maker|
        maker.channel.title = site.config['name']
        maker.channel.link = site.config['url']
        maker.channel.description = site.config['description'] || "Atom feed for #{site.config['name']}"
        maker.channel.author = site.config["author"]
        maker.channel.updated = Time.now
        maker.channel.copyright = site.config['copyright']

        items_number = site.config['posseify_items_number'].nil? ? site.posts.docs.count : site.config['posseify_items_number'] - 1

        site.posts.docs.reverse[0..items_number].each do |doc|
          doc.read
          maker.items.new_item do |item|
            link = "#{site.config['url']}#{doc.url}"
            item.title = doc.data['title']
            item.link = link
            item.guid.content = link
            item.updated = doc.date
            item.pubDate = doc.date

            item.summary = "<![CDATA[" + doc.data['excerpt'].to_s.gsub(%r{</?[^>]+?>}, '') + "]]>"

            # https://stackoverflow.com/a/26027221/717195
            item.content.content = doc.content

            # the whole doc content, wrapped in CDATA tags
            item.content_encoded = "<![CDATA[" + doc.content + "]]>"
          end
        end
      end

      # File creation and writing
      atom_path = ensure_slashes(site.config['atom_path'] || "/feeds/")
      atom_name = site.config['atom_name'] || "atom.xml"
      full_path = File.join(site.dest, atom_path)
      ensure_dir(full_path)

      # We only have HTML in our content_encoded field which is surrounded by CDATA.
      # So it should be safe to unescape the HTML.
      feed = CGI::unescapeHTML(rss.to_s)

      # Add the feed page to the site pages
      site.static_files << Jekyll::AtomFeed.new(site, site.dest, atom_path, atom_name, feed)
    end

    private

    # Ensures the given path has leading and trailing slashes
    #
    # path - the string path
    #
    # Return the path with leading and trailing slashes
    def ensure_slashes(path)
      ensure_leading_slash(ensure_trailing_slash(path))
    end

    # Ensures the given path has a leading slash
    #
    # path - the string path
    #
    # Returns the path with a leading slash
    def ensure_leading_slash(path)
      path[0] == "/" ? path : "/#{path}"
    end

    # Ensures the given path has a trailing slash
    #
    # path - the string path
    #
    # Returns the path with a trailing slash
    def ensure_trailing_slash(path)
      path[-1] == "/" ? path : "#{path}/"
    end

    # Ensures the given directory exists
    #
    # path - the string path of the directory
    #
    # Returns nothing
    def ensure_dir(path)
      FileUtils.mkdir_p(path)
    end


  end
end
