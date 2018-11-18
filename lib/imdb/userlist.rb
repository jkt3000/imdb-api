module IMDB

  class Userlist < ListBase

    LIST_URL = "https://www.imdb.com/list/LISTID"
    LIST_KEY = 'itemListElement'

    def self.get(url)
      url       = sanitize_url(url)
      list_id   = url.split("/").last
      response  = RestClient.get(url)
      page      = Nokogiri::HTML(response.body)
      content   = page.css('script[type="application/ld+json"]').first
      list_hash = JSON.parse(content.children.first)
      new(list_hash, id: list_id)
    end


    def initialize(list_hash, id: nil)
      @id    = id
      @name  = list_hash.fetch('name', nil)
      @description = list_hash.fetch('description', nil)
      @list  = list_hash.fetch('about',{})
      @items = parse_list_items(LIST_KEY)
      @titles = {}
      parse_titles
    end


    private
    
    def id_from_entry(entry)
      entry['url'].scan(/\/title\/(.+)\//).first.first
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