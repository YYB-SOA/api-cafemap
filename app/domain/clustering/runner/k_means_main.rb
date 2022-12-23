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
  info_obj = infos_data.select { |filter| filter.address.include? city }
  store_obj = info_obj.map { |info_data| info_data.store[0] }

  def df_transformer(object)
    df = Rover::DataFrame.new({})
    colnames_array = object[0].keys
    colnames_array.each do |col|
      value_array = object.map { |data| data.method(col).call }
      df[col] = value_array
    end
    df
  end

  df_info = df_transformer(info_obj)
  df_store = df_transformer(store_obj)

  # Slower Method
  df_info.inner_join(df_store, on: { id: :info_id })
end

# Example usage:
CITI_LIST = ["新竹"].freeze
CITI_LIST.each do |city|
  df = create_data_frame_for_city(city).except!(:created_at, :updated_at)
  df_js = df.to_a.to_s
  # Write the JSON object to a file
  File.write("app/domain/clustering/temp/#{city}_clustering_input.txt", df_js)
  sleep 3
  # Pass the string to python directly
  %x[python app/domain/clustering/algo/k_means.py #{city}]
  
end
