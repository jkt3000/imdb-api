module IMDB

  class Media

    BASE_URL  = "https://www.imdb.com"
    QUERY_URL = BASE_URL + "/title/data" 

    def self.get(ids = [])
      ids = [ids].flatten
      response = RestClient.get(QUERY_URL, params: {ids: ids.join(",")})
      list = JSON.parse(response.body)
      list.inject({}) do |hash, entry|
        hash[entry.first] = entry.last['title']
        hash
      end
    end

  end

end