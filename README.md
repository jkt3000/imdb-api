# imdb-api

Ruby gem that hacks IMDB to provide simple API for some basic functionality.

**Disclaimer**: This could stop working at anytime so use at your own risk! This is a hack, as it parses the JSON in the html of regular pages for it to work. 

It so far provides only the following functionality:

* watchlists
* user lists
* query IMDB for movie information in JSON format based on their imdb id.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'imdb-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install imdb-api


## Usage

#### Watchlists

In the html of a watchlist URL, there is a line of javascript which contains the JSON of the entire watchlist. We simply parse the page and extract the JSON and convert into ruby hash for easy usage). 

The of code we are looking for looks like:
```
  ...
  IMDbReactInitialState.push(<json of watchlist>);
  ...
```

Simplying parsing that line and extract the json yields us the watchlist in JSON format.


```
  watchlist = IMDB::Watchlist.get(url|user_id)

  eg:

  watchlist = IMDB::Watchlist.get("https://www.imdb.com/user/XXXXXXX/watchlist")
  watchlist = IMDB::Watchlist.get("urXXXXXXX")

  watchlist.name    # name of list
  watchlist.id      # imdb id for the list
  watchlist.items   # array of watchlist items (imdb_id, title, position, added_at)
  watchlist.to_hash # hash of list with keys ['id', 'name', 'description', 'items']

  { 
    "id"=>"ls031812414",
    "name"=>"john-11855's Watchlist",
    "description"=>nil,
    "items"=> [
      {
        "imdb_id"=>"tt2025690",
        "title"=>"The Finest Hours",
        "position"=>1,
        "added_at"=>#<Date: 2016-01-22 ((2457410j,0s,0n),+0s,2299161j)>
      },
      {
        "imdb_id"=>"tt2140037",
        "title"=>"Jane Got a Gun",
        "position"=>2,
        "added_at"=>#<Date: 2016-01-22 ((2457410j,0s,0n),+0s,2299161j)>
      },
      ...
    ]
  }
```

where:
* user_id is the urXXXXX part in the URL:  https://www.imdb.com/user/XXXXXXX/watchlist
* You can supply either the urXXXX id or just copy & paste the whole URL


#### User Lists

In the html of a user list URL, there is a script tag which contains the entire user list in JSON format. We simply parse the page and extract the JSON and convert into ruby hash for easy usage). 

In the ```<head>``` of the page, look for the tag ```<script type="application/ld+json">...</script>``` and parse the contents of that tag to get the user list in JSON format.



```
  list = IMDB::Userlist.get(url|list_id)

  eg:

  list = IMDB::Userlist.get("https://www.imdb.com/list/ls040518607")
  list = IMDB::Userlist.get("ls040518607")

  list.to_hash

  {
    "id"=>"ls040518607",
    "name"=>"Good Scifi",
    "description"=>"List of Good Sci Fi movies",
    "items"=> [
      {
        "imdb_id"=>"tt1631867",
        "title"=>"Edge of Tomorrow",
        "position"=>"1",
        "added_at"=>nil
      },
      {
        "imdb_id"=>"tt1483013",
        "title"=>"Oblivion",
        "position"=>"2",
        "added_at"=>nil
      },
      ...
    ]
  }
```

#### Querying Titles in IMDB

In the list/userlist pages on IMDB, the page makes ajax calls to a data URL to get media information in JSON format for an array of imdb_ids. 

The data URL endpoint is ```https://www.imdb.com/title/data?ids=tt12345,tt12346,...```



```
  medias = IMDB::Media.get(<array of IMDBids>)

  eg:

  medias = IMDB::Media.get(["tt2226597", "tt0974015"])

  media = medias.first

  pp media

  {
    "tt0111282" =>  {
      "credits" =>  {
        "star" =>  [
          {"href" => "/name/nm0000621", "name" => "Kurt Russell"},
          {"href" => "/name/nm0000652", "name" => "James Spader"},
          {"href" => "/name/nm0001109", "name" => "Jaye Davidson"},
          {"href" => "/name/nm0511798", "name" => "Viveca Lindfors"}
        ],
        "director" => [
          {"href" => "/name/nm0000386", "name" => "Roland Emmerich"}
        ]
      },
      "id" => "tt0111282",
      "metadata" =>  {
        "certificate" => "PG-13",
        "genres" => ["Action", "Adventure", "Sci-Fi"],
        "release" => 783302400000,
        "runtime" => 6960
      },
      "movieMeterCurrentRank" => 1711,
      "plot" => 
        "An interstellar teleportation device, found in Egypt, leads to a planet with humans resembling ancient Egyptians who worship the god Ra.",
      "poster" =>  {
        "height" => 931,
        "url" => 
          "https://m.media-amazon.com/images/M/MV5BYWEyYTQzNzQtZTg5OS00NDhkLTg1NjYtMzA5Y2MyYjYzNWQ5L2ltYWdlL2ltYWdlXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_.jpg",
        "width" => 597
      },
      "primary" =>  {
        "href" => "/title/tt0111282", 
        "title" => "Stargate", 
        "year" => ["1994"]
      },
      "ratings" =>  {
        "canVote" => true, 
        "metascore" => 42, 
        "rating" => 7.1, 
        "votes" => 162392
      },
      "type" => "featureFilm"
    }
  }

```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## TODO

* yeah, there's no tests
