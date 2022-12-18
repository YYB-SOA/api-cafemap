
# Should pass the valid city_list in this runner file
# 概念::  
# 1. 收到string_array 包含多個地區的要求，例如[新竹、桃園、台北、嘉義、南投]
# 2. 將資料庫中屬於同地區的資料拉出來變成hash,放進hash中，得到key為地區名稱，value用hash包著為該地區資料
## Ex. {"台北" =>  {台北地區資料hash}, "桃園" =>  {桃園地區資料hash},"新竹" =>  {新竹地區資料hash}}

# 3. 將hash 傳入split_into_multiple，分成n組hash array
# 4. 將組資料的value傳入data_preprocessing.ipynb中，處理好資料再傳到K means中，k means return value
# 5. K means return 資料(為hash, key 為store_id，value為cluster編號)， 等待各treading完成，合併hash
require_relative '../../spec/helpers/spec_helper.rb'

# -- How to use split_into_multiple func--
big_hash = {"新竹" => "value1", "台北" => "value2", "高雄" => "value3","桃園" => "value4","南投" => "value5"}
# subhashes = split_into_multiple(big_hash)
# # The subhashes array will contain three hashes:
# # {"新竹" => "value1", "台北" => "value2"}
# # {"高雄" => "value3", "桃園" => "value4"}
# # {"南投" => "value5"}
result = CafeMap::Database::InforOrm.all

area_data = infos_data.select { |filter| filter.address.include? "新竹" }
area_data.map{|info_data| info_data.store[0]}

def split_into_multiple(big_hash, n_set =3)
    # Initialize an array to store the subhashes
    subhashes = []
  
    # Split the hash into three subhashes using the each_slice method
    big_hash.each_slice(n_set) do |slice|
      subhashes << slice
    end
  
    # If the last subhash has fewer than 3 elements, remove it
    subhashes.pop if subhashes.last.length < n_set
  
    # Convert the arrays of key-value pairs into hashes
    subhashes.map { |slice| Hash[slice] }
end



# area_store_list = CafeMap::Service::StoreList::MiningStore

# # Load balance
# partial_store_block = split_into_narray(area_store_list)
store_hash = split_into_multiple(big_hash)
print(store_hash)
# for store in partial_store_block:
output = %x[python lib/algo/data_preprocessing.ipynb store_hash]
# end
# puts output