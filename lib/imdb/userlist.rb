module IMDB

  class Userlist
  end

end


# Parsing a regular imdb list

# req     = RestClient.get "https://www.imdb.com/list/ls068149248/"
# page    = Nokogiri::HTML(req.body)
# content = page.css('script[type="application/ld+json"]').first
# script  = JSON.parse(content.children.first)

# {"@context"=>"http://schema.org",
#  "@type"=>"CreativeWork",
#  "about"=>
#   {"@type"=>"ItemList",
#    "itemListElement"=>
#     [{"@type"=>"ListItem", "position"=>"1", "url"=>"/title/tt2397535/"},
#      {"@type"=>"ListItem", "position"=>"2", "url"=>"/title/tt1772264/"},
#      {"@type"=>"ListItem", "position"=>"3", "url"=>"/title/tt1130884/"},
#      {"@type"=>"ListItem", "position"=>"4", "url"=>"/title/tt6499752/"},
#      {"@type"=>"ListItem", "position"=>"5", "url"=>"/title/tt2854926/"},
#      {"@type"=>"ListItem", "position"=>"6", "url"=>"/title/tt4682788/"},
#      {"@type"=>"ListItem", "position"=>"7", "url"=>"/title/tt1375666/"},
#      {"@type"=>"ListItem", "position"=>"8", "url"=>"/title/tt4972582/"}]},
#  "dateModified"=>"2018-09-07T14:32Z",
#  "name"=>"I would recommend",
#  "description"=>
#   "My favorites, movies /w twist, thrilling and different, I would watch again and recommend."}