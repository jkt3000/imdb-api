module IMDB

  class Userlist

    LIST_URL = "https://www.imdb.com/list/LISTID"
    DATA_URL = "https://www.imdb.com/title/data"

    def self.get(url)
      url       = sanitize_url(url)
      list_id   = url.split("/").last
      response  = RestClient.get(url)
      page      = Nokogiri::HTML(response.body)
      content   = page.css('script[type="application/ld+json"]').first
      list_hash = JSON.parse(content.children.first)
      new(list_hash, id: list_id)
    end


    attr_reader :id, :name, :description, :list, :items, :titles

    def initialize(list_hash, id: nil)
      @id    = id
      @name  = list_hash.fetch('name', nil)
      @description = list_hash.fetch('description', nil)
      @list  = list_hash.fetch('about',{})
      @items = parse_list_items('itemListElement')
      @titles = {}
      parse_titles
    end

    def imdb_ids
      @imdb_ids ||= @items.map {|x| x['imdb_id']}
    end

    def to_hash
      {
        'name'  => name,
        'id'    => id,
        'items' => items
      }
    end

    def inspect
      "<#{self.class.name} name=\"#{name}\" count=\"#{items.count}\">"
    end

    private


    def title(imdb_id)
      return unless movie = @titles[imdb_id]
      movie['primary']['title']
    end


    def parse_list_items(key)
      @list[key].map do |entry|
        id = entry['url'].scan(/\/title\/(.+)\//).first.first
        {
          "imdb_id"  => id,
          "title"    => nil,
          "position" => entry['position'],
          "added_at" => nil
        }
      end
    end

    def parse_titles
      import_all_titles if missing_titles?
      (0..items.count-1).each do |index|
        @items[index]['title'] = title(@items[index]['imdb_id'])
      end
    end


    def import_all_titles
      response = RestClient.get(DATA_URL, params: {ids: imdb_ids.join(",")})
      list = JSON.parse(response.body)
      entries = list.inject({}) do |hash, entry|
        hash[entry.first] = entry.last['title']
        hash
      end
      @titles.merge!(entries)
    end

    def missing_titles?
      (imdb_ids & titles.keys) != imdb_ids
    end

    def self.sanitize_url(url)
      url =~ URI::regexp ? url : Userlist::LIST_URL.gsub(/LISTID/, url)
    end
  end

end

# Format of response
#
# {"@context"=>"http://schema.org",
#  "@type"=>"CreativeWork",
#  "about"=>
#   {"@type"=>"ItemList",
#    "itemListElement"=>
#     [{"@type"=>"ListItem", "position"=>"1", "url"=>"/title/tt1631867/"},
#      {"@type"=>"ListItem", "position"=>"2", "url"=>"/title/tt1483013/"},
#      {"@type"=>"ListItem", "position"=>"3", "url"=>"/title/tt0111282/"},
#      {"@type"=>"ListItem", "position"=>"4", "url"=>"/title/tt2316204/"},
#      {"@type"=>"ListItem", "position"=>"5", "url"=>"/title/tt0090605/"},
#      {"@type"=>"ListItem", "position"=>"6", "url"=>"/title/tt0078748/"},
#      {"@type"=>"ListItem", "position"=>"7", "url"=>"/title/tt1446714/"}]},
#  "dateModified"=>"2018-10-01T17:14Z",
#  "name"=>"Good Scifi",
#  "description"=>"List of Good Sci Fi movies"}