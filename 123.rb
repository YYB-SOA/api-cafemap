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
cluster_result = CafeMap::Cluster::ClusterMapper.new(fh_result).load_several
# puts cluster_result.length
# cluster_result.each do |each_cluster|
#     CafeMap::Repository::For.entity(each_cluster).create(each_cluster)
# end
# puts CafeMap::Database::ClusterOrm.where(city: input).all.length
# puts CafeMap::Database::InfoOrm.where(city: input).all.length
def check_new_data_in_infoDB?(input)
    info_db_len = CafeMap::Database::InfoOrm.where(city: input).all.length
    cluster_db_len = CafeMap::Database::ClusterOrm.where(city: input).all.length
    info_db_len == cluster_db_len
end
# CafeMap::Database::ClusterOrm.where(city: input).delete
puts CafeMap::Database::InfoOrm.where(city: input).all.length