# ImdbApi

Ruby gem that hacks IMDB to provide simple API for some basic functionality.
* watchlists
* user lists
* query IMDB for movie information in JSON format

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

#### Get a Watchlist:

```
  watchlist = IMDB::Watchlist.get(url|user_id)

  eg:

  watchlist = IMDB::Watchlist.get("https://www.imdb.com/user/urXXXXXXX/watchlist")
  watchlist = IMDB::Watchlist.get("urXXXXXXX")

  watchlist.name  # name of list
  watchlist.id    # imdb id for the list
  watchlist.items # array of watchlist items (imdb_id, title, position, added_at)
```

where:
* user_id is the urXXXXX part in the URL:  https://www.imdb.com/user/urXXXXXXX/watchlist
* Simpler just to supply the entire URL


#### Get a User list:

```
  list = IMDB::List.get(url|list_id)

  eg:

  list = IMDB::List.get("https://www.imdb.com/list/ls040518607")
  list = IMDB::List.get("ls040518607")
```

#### Get info about an array of IMDBids

```
  medias = IMDB::Media.get(<array of IMDBids>)

  eg:

  medias = IMDB::Media.get(["tt2226597", "tt0974015"])
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/imdb_api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## TODO

