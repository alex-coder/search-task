require 'net/http'

API = {
  username: 'alex.coder1@gmail.com',
  api_key: '9e147c4c1c86c872dfbaf692a1c80c7a'
}

CITY_ID = 1

def GET(url, data = {})
  uri = URI(url)
  uri.query = URI.encode_www_form(API.merge(data))
  puts "HTTP GET #{uri.to_s}"
  return JSON.parse(Net::HTTP.get_response(uri).body)
end

tags = []
attractions = []
activities = []

# Getting tags
Tag.destroy_all
categories_data = GET("http://api.sputnik8.com/v1/cities/#{CITY_ID}/categories")[0]['sub_categories']
categories_data.each do |data_item|
  tags << Tag.create!({
    id: data_item['id'].to_i,
    name: data_item['name'].to_s,
    description: data_item['description'].to_s
  })
end
puts "#{tags.length} tags created"

# Getting attractions
Attraction.destroy_all
attractions_data = GET('https://kudago.com/public-api/v1.3/places/?showing_since=1444385206&showing_until=1444385206&location=spb&fields=title,description&text_format=text&page_size=200')['results']
attractions_data.each do |data_item|
  attractions << Attraction.create!({
    city_id: CITY_ID,
    title: data_item['title'].to_s,
    description: data_item['description'].to_s
  })
end
puts "#{attractions.length} attractions created"

# Getting activities
Activity.destroy_all
activities_data = GET("http://api.sputnik8.com/v1/products")
activities_data.each do |data_item|
  activities << Activity.create!({
    id: data_item['id'].to_i,
    city_id: CITY_ID,
    title: data_item['title'].to_s,
    description: data_item['description'].to_s,
    tags: tags.sample(3),
    attractions: attractions.sample(3)
  })
end

puts "#{activities.length} activities created"
