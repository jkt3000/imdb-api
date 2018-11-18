module IMDB

  class ListBase

    BASE_URL  = "https://www.imdb.com"
    TITLE_URL = BASE_URL + "/title/data"
    
    attr_reader :id, :name, :description, :items, :list, :titles



    def to_hash
      {
        'id'          => id,
        'name'        => name,
        'description' => description,
        'items'       => items
      }
    end

    def inspect
      "<#{self.class.name} name=\"#{name}\" count=\"#{items.count}\">"
    end

    def raw_hash
      @list
    end

    def imdb_ids
      @imdb_ids ||= @items.map {|x| x['imdb_id']}
    end


    private

    def parse_list_items(key)
      @list[key].map do |entry|
        id = id_from_entry(entry)
        {
          "imdb_id"  => id,
          "title"    => nil,
          "position" => entry['position'],
          "added_at" => entry['added'] ? Date.parse(entry['added']) : nil
        }
      end
    end

    def id_from_entry(entry)
      raise StandardError, "Not Implemented. Add method in sublcass"
    end


    def title(imdb_id)
      return unless movie = @titles[imdb_id]
      movie['primary']['title']
    end

    def parse_titles
      import_all_titles if missing_titles?
      (0..items.count-1).each do |index|
        @items[index]['title'] = title(@items[index]['imdb_id'])
      end
    end

    def import_all_titles
      response = RestClient.get(TITLE_URL, params: {ids: imdb_ids.join(",")})
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
  end
end