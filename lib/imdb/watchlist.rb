module IMDB

  class Watchlist

    attr_reader :items, :name, :id

    def self.get(user_id)
      url = set_url(user_id)
      response = RestClient.get(url)
      list_json = response.body.match(WATCHLIST_REGEX)[1]
      list = JSON.parse(list_json)
      new(list)
    end


    def initialize(list_hash)
      @list = list_hash.fetch('list')
      @items = list.fetch('items', []).map do |entry|
        {
          "position" => entry.fetch('position'),
          "added"    => Date.parse(entry.fetch('added')),
          "imdb_id"  => entry.fetch('const')
        }
      end
    end

    def name
      list.fetch('name')
    end

    def id
      list.fetch('id')
    end

    def to_hash
      {
        'name' => name,
        'id' => id,
        'items' => items
      }
    end


    def inspect
      "<IMDB::Watchlist name=\"#{name}\" count=\"#{items.count}\">"
    end

    def raw_hash
      @list
    end

    private


    def self.set_url(user_id)
      user_id =~ URI::regexp ? user_id : WATCHLIST_URL.gsub(/USERID/, user_id)
    end
  end

end