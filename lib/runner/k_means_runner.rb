# frozen_string_literal: true

require 'rover-df'
# Should pass the valid city_list in this runner file
# 概念::
# 1. 收到string_array 包含多個地區的要求，例如[新竹、桃園、台北、嘉義、南投]
# 2. 將資料庫中屬於同地區的資料拉出來變成hash,放進hash中，得到key為地區名稱，value用hash包著為該地區資料
## Ex. {"台北" =>  {台北地區資料hash}, "桃園" =>  {桃園地區資料hash},"新竹" =>  {新竹地區資料hash}}

# 3. 將hash 傳入split_into_multiple，分成n組hash array
# 4. 將組資料的value傳入data_preprocessing.ipynb中，處理好資料再傳到K means中，k means return value
# 5. K means return 資料(為hash, key 為store_id，value為cluster編號)， 等待各treading完成，合併hash
# require_relative '../../spec/helpers/spec_helper.rb'

def require_app(folders = %w[infrastructure domain presentation application])
  app_list = Array(folders).map { |folder| "app/#{folder}" }
  full_list = ['config', app_list].flatten.join(',')

  Dir.glob("./{#{full_list}}/**/*.rb").each do |file|
    require file
  end
end
require_app

def split_into_multiple(big_hash, n_set = 3)
  # Initialize an array to store the subhashes
  subhashes = []

  # Split the hash into three subhashes using the each_slice method
  big_hash.each_slice(n_set) do |slice|
    subhashes << slice
  end

  # If the last subhash has fewer than 3 elements, remove it
  subhashes.pop if subhashes.last.length < n_set

  # Convert the arrays of key-value pairs into hashes
  subhashes.map(&:to_h)
end

# -- How to use split_into_multiple func--

CITI_LIST = %(新北 桃園 台中 台南 台南 新北  桃園  基隆 彰化  南投)

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
CITI_LIST = ['新竹'].freeze
CITI_LIST.each do |city|
  df = create_data_frame_for_city(city).except!(:created_at, :updated_at)
  df_js = df.to_a.to_s
  # Write the JSON object to a file
  File.write("lib/temp/#{city}.txt", df_js)

  # Pass the string to python directly

  # IO.popen("python lib/algo/trial.py #{df_js}")
  # output = %x[python lib/algo/trial.py #{df_js}]

  %x[`python lib/algo/clustering/k_means.py`] #若assign 變數會在ruby環境新增一堆不必要的空檔案
  
end
