# frozen_string_literal: true

def require_app(folders = %w[infrastructure domain presentation application])
    app_list = Array(folders).map { |folder| "app/#{folder}" }
    full_list = ['config', app_list].flatten.join(',')
  
    Dir.glob("./{#{full_list}}/**/*.rb").each do |file|
      require file
    end
  end

require_app

city_en= 'changhua'

info_from_db = CafeMap::Database::InfoOrm.where(city: city_en).all
# store_from_db = CafeMap::Database::InfoOrm.where(city: city_en).map { |x| x.store[0] }
cluster_array = []
info_from_db.length.times{cluster_array.append((0..5).to_a.sample)}
cluster_hash_array = []
cluster_array.each_with_index do |value, key|
    info_hash = info_from_db[key].to_hash
    store_hash = info_from_db[key].store[0].to_hash.except(:name)
    merge_hash = info_hash.to_hash.merge(store_hash).except(:created_at, :updated_at)
    temp = {}
    merge_hash.each{|key, value| temp[key.to_s] = value}
    temp['cluster'] = value
    cluster_hash_array.append(temp)
end
test_entity = CafeMap::Cluster::ClusterMapper.new(cluster_hash_array).load_several
puts test_entity