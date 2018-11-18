# Docs

There are two types of lists: Watchlist and lists

## Watchlist

This is a user's specific watchlist. URL format is:

```https://www.imdb.com/user/ur65019493/watchlist```

In the source, there is a line which contains JSON format of the list.

```
  IMDbReactInitialState.push({...lots of json...});
```

By extracting out that line and parsing the JSON, we can turn this into JSON or hash object

```
{
  "user": null,
  "sortOption": "list_order",
  "viewMode": "detail",
  "starbars": {
    "tt2025690": {
      "auth": "",
      "votes": 53892,
      "aggregate": 6.8,
      "rating": 0,
      "id": "tt2025690"
    },
    ...
    ...
  },
  "ribbons": {
    "tt2025690": {
      "inWL": false,
      "tconst": "tt2025690"
    },
    ....
    ....
  },
  "list": {
    "id": "ls031812414",
    "name": "john-11855's Watchlist",
    "description": {
      "html": ""
    },
    "items": [
      {
        "position": 1,
        "added": "22 Jan 2016",
        "itemId": "li867385891",
        "description": {
          "html": ""
        },
        "const": "tt2025690"
      },
      {
        "position": 2,
        "added": "22 Jan 2016",
        "itemId": "li867385978",
        "description": {
          "html": ""
        },
        "const": "tt2140037"
      },
      ...
      ...
    ],
  },
  "titles": {
    "tt2025690": {
      "primary": {
        "href": "/title/tt2025690",
        "year": [
          "2016"
        ],
        "title": "The Finest Hours"
      },
      (bunch more stuff)
    },
    ...
    ...
  }
}    
```

```

Key elements:
  lists   => items in the watchlist
  titles  => hash of movie/show information by imdb_id (only the first 100 will be included). To get the rest, you'll have to make query to /title/data endpoint and parse the response

```


## List

A list is a generic IMDB list made by users.

URL format is:

```
  https://www.imdb.com/list/ls068149248/
```

In the source document, in between the 
```<script[type="application/ld+json"]>....</script>```
at the top of the document contains the JSON of the list. Just need to parse that to get JSON format.



## Movie info in JSON format from IMDB

This request:

```
https://www.imdb.com/title/data?ids=tt1020558,tt1446714,...
```

will return JSON format of movies with the ids provided:

```
{
  "tt1446714": {
    "ribbon": {
      "inWL": true,
      "tconst": "tt1446714"
    },
    "starbar": {
      "aggregate": 7.0,
      "auth": "BCYtGzx1TKRgktov6yySJJniVvE9qyCEZxID1B0ZVkDVR71P4m1qFQT2y0GOICfyR46R0Wqn8Y2B%0D%0AfEZ07uu0Q0e9gD1L3BNi6n5R4tOTSaZUU26u_4UsGFHRjEW916Rf8KlI%0D%0A",
      "id": "tt1446714",
      "rating": 0,
      "votes": 527198
    },
    "title": {
      "credits": {
        "star": [
          {
            "href": "/name/nm0636426",
            "name": "Noomi Rapace"
          },
          {
            "href": "/name/nm1334869",
            "name": "Logan Marshall-Green"
          },
          {
            "href": "/name/nm1055413",
            "name": "Michael Fassbender"
          },
          {
            "href": "/name/nm0000234",
            "name": "Charlize Theron"
          }
        ],
        "director": [
          {
            "href": "/name/nm0000631",
            "name": "Ridley Scott"
          }
        ]
      },
      "id": "tt1446714",
      "metadata": {
        "certificate": "R",
        "genres": [
          "Adventure",
          "Mystery",
          "Sci-Fi"
        ],
        "release": 1339113600000,
        "runtime": 7440
      },
      "movieMeterCurrentRank": 572,
      "plot": "Following clues to the origin of mankind, a team finds a structure on a distant moon, but they soon realize they are not alone.",
      "poster": {
        "height": 2048,
        "url": "https://m.media-amazon.com/images/M/MV5BMTY3NzIyNTA2NV5BMl5BanBnXkFtZTcwNzE2NjI4Nw@@._V1_.jpg",
        "width": 1382
      },
      "primary": {
        "href": "/title/tt1446714",
        "title": "Prometheus",
        "year": [
          "2012"
        ]
      },
      "ratings": {
        "canVote": true,
        "metascore": 64,
        "rating": 7.0,
        "votes": 527198
      },
      "type": "featureFilm"
    }
  },
  "tt1020558": {
    "ribbon": {
      "inWL": true,
      "tconst": "tt1020558"
    },
    "starbar": {
      "aggregate": 6.4,
      "auth": "BCYka_3ip6csCISVNNvPn4luc6eIlTGT_8opINiVpeZIwI4yFdptJyTbIbtTHJ735eijijFXvt8d%0D%0AX3_d5sbqU_AmQVtXT028D2mGSiaJ_-aqiuGgBneaAbK0qRcOU9Ebjd7N%0D%0A",
      "id": "tt1020558",
      "rating": 0,
      "votes": 72281
    },
    "title": {
      "credits": {
        "star": [
          {
            "href": "/name/nm1055413",
            "name": "Michael Fassbender"
          },
          {
            "href": "/name/nm0922035",
            "name": "Dominic West"
          },
          {
            "href": "/name/nm1385871",
            "name": "Olga Kurylenko"
          },
          {
            "href": "/name/nm0936591",
            "name": "Andreas Wisniewski"
          }
        ],
        "director": [
          {
            "href": "/name/nm0551076",
            "name": "Neil Marshall"
          }
        ]
      },
      "id": "tt1020558",
      "metadata": {
        "certificate": "R",
        "genres": [
          "Action",
          "Adventure",
          "Drama",
          "History",
          "Thriller",
          "War"
        ],
        "release": 1280448000000,
        "runtime": 5820
      },
      "movieMeterCurrentRank": 4116,
      "plot": "A splinter group of Roman soldiers fight for their lives behind enemy lines after their legion is devastated in a guerrilla attack.",
      "poster": {
        "height": 2048,
        "url": "https://m.media-amazon.com/images/M/MV5BMTQ4NTI1MTEzM15BMl5BanBnXkFtZTcwNDc3NDc1Mw@@._V1_.jpg",
        "width": 1382
      },
      "primary": {
        "href": "/title/tt1020558",
        "title": "Centurion",
        "year": [
          "2010"
        ]
      },
      "ratings": {
        "canVote": true,
        "metascore": 62,
        "rating": 6.4,
        "votes": 72281
      },
      "type": "featureFilm"
    }
  }
}
```

Therefore, you can easily turn this into a hash and use needed.

```
type:
  featureFilm     -> movie
  series          -> show
```