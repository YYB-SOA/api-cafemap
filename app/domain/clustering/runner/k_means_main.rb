# frozen_string_literal: true

require 'rover-df'


def require_app(folders = %w[infrastructure domain presentation application])
  app_list = Array(folders).map { |folder| "app/#{folder}" }
  full_list = ['config', app_list].flatten.join(',')

  Dir.glob("./{#{full_list}}/**/*.rb").each do |file|
    require file
  end
end

require_app

# def split_into_multiple(big_hash, n_set = 3)
#   # Initialize an array to store the subhashes
#   subhashes = []

#   # Split the hash into three subhashes using the each_slice method
#   big_hash.each_slice(n_set) do |slice|
#     subhashes << slice
#   end

#   # If the last subhash has fewer than 3 elements, remove it
#   subhashes.pop if subhashes.last.length < n_set

#   # Convert the arrays of key-value pairs into hashes
#   subhashes.map(&:to_h)
# end

# # -- How to use split_into_multiple func--

# CITI_LIST = %(新北 桃園 台中 台南 台南 新北  桃園  基隆 彰化  南投)

def create_data_frame_for_city(city)
  # Get two obj from db
  infos_data = CafeMap::Database::InfoOrm.all
  puts "infos_data success"
  info_obj = infos_data.select { |filter| filter.address.include? city }
  puts "info_obj success"
  store_obj = info_obj.map { |info_data| info_data.store[0] }
  puts "store_obj success as following: #{store_obj}"
  
  def df_transformer(object, type = "info")
    # object is the entity use the db from InfoOrm and StoreOrm
    df = Rover::DataFrame.new({})
    colnames_array = object[0].keys
    # colnames_array.remove(":id")
    puts colnames_array
    if type == "info"
      colnames_array.each do |col|
        value_array = object.map { |data| data.method(col).call }
        df[col] = value_array 
      end
    else
      puts "Store db converting stat:---->"
      # colnames_array = colnames_array.delete("id")
      colnames_array.each do |col|
        puts "Run #{col} --->"
        # puts object

        value_array = object.map { |data| data.method(col).call }
        df[col] = value_array
      end
    end
    df
  end
  puts store_obj
  df_info = df_transformer(info_obj)
  puts "df_transformer df_info success"
  df_store = df_transformer(store_obj,"store")
  puts "df_transformer df_store success"

  # Slower Method
  df_info.inner_join(df_store, on: { id: :info_id })
  # puts "inner_join success"

end

# Example usage:
CITI_LIST = ["花蓮"].freeze
CITI_LIST.each do |city|
  df = create_data_frame_for_city(city).except!(:created_at, :updated_at)
  df_js = df.to_a.to_s

  # Write the JSON object to a file
  File.write("app/domain/clustering/temp/#{city}_clustering_input.txt", df_js)
  sleep 3

  # Pass the string to python directly
  %x[python app/domain/clustering/algo/k_means.py #{city}]
  
end
