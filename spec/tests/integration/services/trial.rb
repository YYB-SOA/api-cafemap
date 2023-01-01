
require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

input = Hash[city: 'nantou']
puts "input[:city]:  #{input[:city]}"

# info = CafeMap::Database::InfoOrm.where(city: input[:city])
# puts "\n\n info: #{info}"
#### PS1: 若篩選用city必須為英文輸入
# info = CafeMap::Database::InfoOrm.where(city: input[:city])
# puts "\n\n InfoOrm database in dev: \n#{info.all}"


city_en ="nantou"
rep__info = CafeMap::Repository::Infos.fetch_by_city(city_en)
puts "\n\n fetch_by_city: #{rep__info}"

# CafeMap::Database::InfoOrm.where(city: city_en)#.all
# info_from_db ="info_from_db#{info_from_db}"


info_from_db = CafeMap::Database::InfoOrm.where(city: "nantou").all

puts "\n\ninfo_from_db: \n#{info_from_db}"
# rep__info = CafeMap::Repository::Infos.fetch_by_address(city_zh).

# puts "\n\n city_zh: #{rep__info}"

# infoDB =  CafeMap::Database::InfoOrm.regional(input[:city])#.select { |each| each.city.include? city }
# puts "\n\n infoDB hardcode: #{infoDB}"

# list = CafeMap::Response::InfoList.new(info)
# puts "\n\n list: #{list}"
# # result = Response::ApiResult.new(status: :ok, message: list)
# puts "\n\n result: #{result}"


# aa =  CafeMap::Service::MiningInfo.where(city: input[:city])
# puts "aa: #{aa}"get_info_from_db