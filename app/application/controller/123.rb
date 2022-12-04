def require_app(folders = %w[infrastructure domain presentation application])
  app_list = Array(folders).map { |folder| "app/#{folder}" }
  full_list = ['config', app_list].flatten.join(',')

  Dir.glob("./{#{full_list}}/**/*.rb").each do |file|
    require file
  end
end

require_app

puts '---------'

a =  CafeMap::Database::InfoOrm.all.first
puts a
b = CafeMap::Representer::Info.new(a)
puts b.to_json

require 'roar/decorator'
require 'roar/json'
require 'sequel'
require 'active_record'

result = Struct.new(:composers)

class SongRepresenter < Roar::Decorator
  include Roar::JSON
  collection :composers
end

test = result.new(%w[Fong Yuan])
puts SongRepresenter.new(test).to_json
