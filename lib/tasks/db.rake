require 'net/http'

API = {
  username: 'alex.coder1@gmail.com',
  api_key: '9e147c4c1c86c872dfbaf692a1c80c7a'
}

COUNTRY_ID = 1
CITIES_COUNT = 3

def GET(url, data = {}, auth: true)
  uri = URI(url)
  uri.query = URI.encode_www_form(auth ? API.merge(data) : data)
  puts "HTTP GET #{uri.to_s}"
  return JSON.parse(Net::HTTP.get_response(uri).body)
end

namespace :db do
  desc "Filling database with testing data"
  task fill: :environment do
    Rake::Task['db:fill_cities'].invoke
    Rake::Task['db:fill_tags'].invoke
    Rake::Task['db:fill_attractions'].invoke
    Rake::Task['db:fill_activities'].invoke
  end

  desc "Fill db with cities"
  task fill_cities: :environment do
    # Getting cities
    # TODO Limit parameter is not working
    City.destroy_all
    GET('http://api.sputnik8.com/v1/cities', {country_id: COUNTRY_ID, limit: CITIES_COUNT})
      .each do |data_item|
        City.create!({
          id: data_item['id'].to_i,
          name: data_item['name'].to_s
        })
      end
    puts "#{City.count} cities created"
  end

  desc "Fill db with tags"
  task fill_tags: :environment do
    # Getting tags
    Tag.destroy_all
    City.all.each do |city|
      puts "Getting city #{city.id} data"
      GET("http://api.sputnik8.com/v1/cities/#{city.id}/categories")[0]['sub_categories']
        .each do |data_item|
          new_id = data_item['id'].to_i
          unless Tag.exists?(new_id)
            Tag.create!({
              id: new_id,
              name: data_item['name'].to_s,
              description: data_item['description'].to_s
            })
          end
        end
    end
    puts "#{Tag.count} tags created"
  end

  desc "Fill db with attractions"
  task fill_attractions: :environment do
    # Getting attractions
    cities = City.all
    Attraction.destroy_all
    params = {
      showing_since: 1444385206,
      showing_until: 1444385206,
      location: 'spb',
      fields: 'title,description',
      text_format: 'text',
      page_size: 200
    }
    GET('https://kudago.com/public-api/v1.3/places/', params, auth: false)['results']
      .each do |data_item|
        puts data_item
        Attraction.create!({
          city_id: cities.sample.id,
          title: data_item['title'].to_s,
          description: data_item['description'].to_s
        })
      end
    puts "#{Attraction.count} attractions created"
  end

  desc "Fill db with activities"
  task fill_activities: :environment do
    tags = Tag.all
    attractions = Attraction.all
    Activity.destroy_all
    # Getting activities
    GET("http://api.sputnik8.com/v1/products")
      .each do |data_item|
        Activity.create!({
          id: data_item['id'].to_i,
          city_id: data_item['city_id'].to_i,
          title: data_item['title'].to_s,
          description: data_item['description'].to_s,
          tags: tags.sample(3),
          attractions: attractions.sample(3)
        })
      end
    puts "#{Activity.count} activities created"
  end
end
