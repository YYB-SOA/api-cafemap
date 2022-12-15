# frozen_string_literal: true

def require_app(folders = %w[infrastructure domain presentation application])
    app_list = Array(folders).map { |folder| "app/#{folder}" }
    full_list = ['config', app_list].flatten.join(',')
  
    Dir.glob("./{#{full_list}}/**/*.rb").each do |file|
      require file
    end
  end

  
require_app

puts "-------------"

a = [CafeMap::Database::InfoOrm.last]
puts a
b = [CafeMap::Database::StoreOrm.last]
puts b
CList = Struct.new(:infos, :stores)
temp = CList.new(a, b )
puts CafeMap::Representer::CafeList.new(temp).to_json
            