require 'json'

input = 'changhua'
fh = JSON.parse(File.read(("app/domain/clustering/temp/#{input}_clustering_out.json")))

def json_to_hash_array(fh)
  return_array = []
  fh.each do |key1, _value1|
    if key1 == 'id'
      fh[key1].each do |_key2, value2|
        temp = {}
        temp[key1] = value2
        return_array.append(temp)
      end
    else
      return_array.each_with_index do |element, index|
        element[key1] = fh[key1][index.to_s]
      end
    end
  end
  return_array
end

def require_app(folders = %w[infrastructure domain presentation application])
  app_list = Array(folders).map { |folder| "app/#{folder}" }
  full_list = ['config', app_list].flatten.join(',')

  Dir.glob("./{#{full_list}}/**/*.rb").each do |file|
    require file
  end
end

require_app
fh_result = json_to_hash_array(fh)
puts fh_result
puts '-------'
a = CafeMap::Cluster::ClusterMapper.new(fh_result).load_several
puts a
puts a[0].name
puts a[1].name
