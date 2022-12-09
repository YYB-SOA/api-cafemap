def require_app(folders = %w[infrastructure domain presentation application])
    app_list = Array(folders).map { |folder| "app/#{folder}" }
    full_list = ['config', app_list].flatten.join(',')

    Dir.glob("./{#{full_list}}/**/*.rb").each do |file|
      require file
    end
  end

require_app

puts "---------"

# a =  CafeMap::Database::InfoOrm.all
# puts a
# b = CafeMap::Representer::InfosList.new(a)
# puts b.to_json

# require 'roar/decorator'
# require 'roar/json'
# result = Struct.new(:title, :composers)

# class SongRepresenter < Roar::Decorator
#   include Roar::JSON

#   property :title
#   collection :composers
# end

# test = result.new('123', ['Fong', "Yuan"])
# SongRepresenter.new(test)

filtered_info = CafeMap::Database::InfoOrm.where(city: "hsinchu").all
google_data = filtered_info.map{|x| x.store[0]} 

b = CafeMap::Response::StoreList.new(google_data)
puts CafeMap::Representer::StoresList.new(b).to_json



# a = Struct.new(:info)
# b = a.new({info: filtered_info})
# c = CafeMap::Representer::InfosList.new(b).to_json
# puts c
# Representer::StoresList.new(google_data).to_json