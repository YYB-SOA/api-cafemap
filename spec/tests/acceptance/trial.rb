# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/acceptance_helper'
require 'cgi'
require 'rack/test'
# abc = {'city'=> '新竹'}
# PARAMS_DEFAULT = {'city'=> '新竹'}
# abc = PARAMS_DEFAULT.dup
# city_request = CafeMap::Request::EncodedCityName.new(abc)

# puts "city_request: #{city_request}" # Success("新竹")
# store_made = CafeMap::Service::AddCafe.new.call(city_request: city_request)

# # puts "\n\n success? \n #{store_made.success?}" #true

# puts "\n\n method of  store_made.value!: \n #{store_made.value!.methods}"
# puts "\n\n store_made.value:  \n #{store_made.value!}"

# puts "\n\n\n"
# puts "\n\n method of  store_made.value!: \n #{store_made.methods}"
# puts "\n\n method of  store_made.nil?: \n #{store_made.nil?}" #false
# puts "\n\n method of  store_made.frozen?: \n #{store_made.frozen?}" #false
# js = CafeMap::Representer::CafeList.new(store_made.value!.message).to_json
# hash  = eval(js)
# info_hash = hash[:infos]
# stores_hash = hash[:stores]

#############
# infoid =  info_hash.map{|row|row[:infoid]}
# puts infoid.all? { |element| element.must_be_instance_of String }

require 'minitest/autorun'

describe 'DataTypeTest' do
  describe 'TestCase1' do
    it 'should test that all elements are strings' do
      PARAMS_DEFAULT = { 'city'=> '新竹' }.freeze
      abc = PARAMS_DEFAULT.dup
      puts "abc: #{abc}\n\n"
      city_request = CafeMap::Request::EncodedCityName.new(abc)
      puts "Assigned City:#{city_request.uncode_cityname}"
      store_made = CafeMap::Service::AddCafe.new.call(city_request:)
      js = CafeMap::Representer::CafeList.new(store_made.value!.message).to_json
      hash = eval(js)
      puts "js: #{js}\n\n"
      info_hash = hash[:infos]
      puts "info_hash: #{info_hash}\n\n"
      stores_hash = hash[:stores]
      puts "stores_hash: #{stores_hash}\n\n"
      ### infoid & name can not be nil
      info_hash.map { |row| row[:infoid] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:name] }.all? { |element| _(element).must_be_instance_of String }

      ## The cafeshop must comes from the specific city
      info_hash.map { |row| row[:address] }.all? { |element| _(element).must_include city_request.uncode_cityname }
      info_hash.map { |row| row[:city] }.all? { |element| _(element).must_include city_request.uncode_cityname }
    end
  end
end
# puts stores_hash.length
# infos_entity = js["infos"]
# stores_entity = js["stores"]
# puts infos_entity
