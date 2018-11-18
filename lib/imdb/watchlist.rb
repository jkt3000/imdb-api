module IMDB

  class Watchlist

    attr_reader :list, :items, :name, :id, :titles


    BASE_URL      = "https://www.imdb.com"
    DATA_URL       = BASE_URL + "/title/data"
    LIST_URL       = BASE_URL + "/user/USERID/watchlist"
    RESPONSE_REGEX = /IMDbReactInitialState\.push\((.*)\)/

    def self.get(url)
      url = sanitize_url(url)
      response = RestClient.get(url)
      list_json = response.body.match(RESPONSE_REGEX)[1]
      list_hash = JSON.parse(list_json)
      new(list_hash['list'], list_hash['titles'])
    end


    def initialize(list, titles)
      @list   = list
      @name   = list.fetch('name')
      @id     = list.fetch('id')
      @titles = titles
      @items  = parse_list_items
      parse_titles
    end

    def to_hash
      {
        'name'  => name,
        'id'    => id,
        'items' => items
      }
    end

    def inspect
      "<IMDB::Watchlist name=\"#{name}\" count=\"#{items.count}\">"
    end

    def raw_hash
      @list
    end

    def imdb_ids
      @imdb_ids ||= @items.map {|x| x['imdb_id']}
    end


    private

    def title(imdb_id)
      return unless movie = @titles[imdb_id]
      movie['primary']['title']
    end

    def parse_list_items
      @list['items'].map do |entry|
        id = entry['const']
        {
          "imdb_id"  => id,
          "title"    => nil,
          "position" => entry['position'],
          "added_at" => Date.parse(entry['added'])
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


    def self.sanitize_url(user_id)
      user_id =~ URI::regexp ? user_id : Watchlist::LIST_URL.gsub(/USERID/, user_id)
    end
  end

end