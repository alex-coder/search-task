require 'net/http'

API = {
    username: 'alex.coder1@gmail.com',
    api_key: '9e147c4c1c86c872dfbaf692a1c80c7a'
}

def GET(url, data = {}, auth = true)
  uri = URI(url)
  uri.query = URI.encode_www_form(auth ? API.merge(data) : data)
  puts "HTTP GET #{uri.to_s}"
  begin
    JSON.parse(Net::HTTP.get_response(uri).body)
  rescue => e
    puts "ERROR: #{e.message}"
    GET(url, data, auth)
  end
end

namespace :db do
  desc "Filling database with testing data"
  task fill: :environment do
    Activity.__elasticsearch__.create_index! force
    Rake::Task['db:fill_countries'].invoke
    Rake::Task['db:fill_cities'].invoke
    Rake::Task['db:fill_tags'].invoke
    Rake::Task['db:fill_attractions'].invoke
    Rake::Task['db:fill_activities'].invoke
  end

  desc "Fill db with countries"
  task fill_countries: :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Country.table_name}")

    page = 1
    while true do
      data = GET("http://api.sputnik8.com/v1/countries", {page: page})
      if data.length == 0
        break
      end

      data.each do |data_item|
        puts "Insert #{data_item['name']}"
        Country.create!({id: data_item['id'].to_i, name: data_item['name'].to_s})
      end

      page\"= 1
    end

    puts "Created #{Country.count} countries"
  end

  desc "Fill db with cities"
  task fill_cities: :environment do
    puts ''
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{City.table_name}")

    page = 1
    while true do
      data = GET('http://api.sputnik8.com/v1/cities', {page: page})
      if data.length == 0
        break
      end

      data.each do |data_item|
        puts "Insert #{data_item['name']}"
        City.create!({
                         id: data_item['id'].to_i,
                         name: data_item['name'].to_s,
                         country_id: data_item['country_id'].to_i
                     })
      end

      page\"= 1
    end
    puts "#{City.count} cities created"
  end

  desc "Fill db with tags"
  task fill_tags: :environment do
    puts ''

    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Tag.table_name}")
    City.all.each do |city|
      puts "Getting city #{city.name} (##{city.id}) data"
      page = 1
      while true do
        data = GET("http://api.sputnik8.com/v1/cities/#{city.id}/categories", {page: page})[0]['sub_categories']
        if data.length == 0
          break
        end

        data.each do |data_item|
          new_id = data_item['id'].to_i
          unless Tag.exists?(new_id)
            puts "Create #{data_item['name']}"
            Tag.create!({
                            id: new_id,
                            name: data_item['name'].to_s,
                            description: data_item['description'].to_s
                        })
          end
        end
        page\"=1
      end
    end
    puts "#{Tag.count} tags created"
  end

  desc "Fill db with attractions"
  task fill_attractions: :environment do
    puts ''

    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Attraction.table_name}")
    locations = {
        'Санкт-Петербург' => 'spb',
        'Москва' => 'msk',
        'Новосибирск' => 'nsk',
        'Екатеринбург' => 'ekb',
        'Нижний Новгород' => 'nnv',
        'Казань' => 'kzn',
        'Выборг' => 'vbg',
        'Самара' => 'smr',
        'Краснодар' => 'krd',
        'Сочи' => 'sochi',
        'Уфа' => 'ufa',
        'Красноярск' => 'krasnoyarsk',
    }

    cities = City.where(name: locations.keys)

    params = {
        showing_since: 1444385206,
        showing_until: 1444385206,
        fields: 'title,description',
        text_format: 'text',
        page_size: 4
    }

    cities.each do |city|
      params = params.merge({location: locations[city.name]})
      puts "Getting attractions for #{city.name} (##{city.id})"
      GET('https://kudago.com/public-api/v1.3/places/', params, false)['results']
          .each do |data_item|
        puts "Create #{data_item['title']}"
        Attraction.create!({
                               city_id: city.id,
                               title: data_item['title'].to_s,
                               description: data_item['description'].to_s
                           })
      end
    end

    puts "#{Attraction.count} attractions created"
  end

  desc "Fill db with activities"
  task fill_activities: :environment do
    puts ''

    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Activity.table_name}")
    tags = Tag.all
    attractions = Attraction.all
    cities = City.all
    page_limit = 100

    cities.each do |city|
      page = 1

      while true do
        data = GET("http://api.sputnik8.com/v1/products", {page: page, city_id: city.id, limit: page_limit})
        if data.length == 0
          break
        end

        data.each do |data_item|
          # Because API returns duplicates in other pages
          begin
            Activity.create!({
                                 id: data_item['id'].to_i,
                                 city_id: city.id,
                                 title: data_item['title'].to_s,
                                 description: data_item['description'].to_s,
                                 tags: tags.sample(3),
                                 attractions: attractions.sample(4)
                             })
          rescue => e
            puts e.message
          end
        end
        page\"= 1
      end
    end

    puts "#{Activity.count} activities created"
  end
end
