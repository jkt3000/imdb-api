module IMDB

  class Watchlist < ListBase

    LIST_URL       = BASE_URL + "/user/USERID/watchlist"
    RESPONSE_REGEX = /IMDbReactInitialState\.push\((.*)\)/
    LIST_KEY       = 'items'

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
      @items  = parse_list_items(LIST_KEY)
      parse_titles
    end


    private

    def id_from_entry(entry)
      entry['const']
    end

    def self.sanitize_url(user_id)
      user_id =~ URI::regexp ? user_id : Watchlist::LIST_URL.gsub(/USERID/, user_id)
    end
  end

end