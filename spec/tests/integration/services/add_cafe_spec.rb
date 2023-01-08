# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Add_Cade Service Integration Test' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_cafe(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve cafe shop info success or not' do
    before do
      DatabaseHelper.wipe_database
      # PARAMS_DEFAULT = {'city'=> '新竹'}
      # abc = PARAMS_DEFAULT.dup
      abc = { 'city'=> '新竹' }.dup
      city_request = CafeMap::Request::EncodedCityName.new(abc)
      @city_assign = city_request.uncode_cityname
      @store_made = CafeMap::Service::AddCafe.new.call(city_request:)
    end

    it 'HAPPY: should be able to find and save remote data into to db' do
      _(@store_made.success?).must_equal true
      _(@store_made.nil?).must_equal false
      _(@store_made.frozen?).must_equal false
    end

    it 'The retrieve data have to match the schema' do
      js = CafeMap::Representer::CafeList.new(@store_made.value!.message).to_json
      hash = eval(js)
      info_hash = hash[:infos]
      stores_hash = hash[:stores]
      _(info_hash.length).must_equal stores_hash.length
      ### infoid & name can not be nil
      info_hash.map { |row| row[:infoid] }.all? { |element| _(element).must_be_instance_of String }
      info_hash.map { |row| row[:name] }.all? { |element| _(element).must_be_instance_of String }
    end
    it 'The retrieve data must comes from the specific city' do
      js = CafeMap::Representer::CafeList.new(@store_made.value!.message).to_json
      hash = eval(js)
      info_hash = hash[:infos]
      stores_hash = hash[:stores]
      info_hash.map { |row| row[:address] }.all? { |element| _(element).must_include @city_assign }
      info_hash.map { |row| row[:city] }.all? { |element| _(element).must_include @city_assign }
    end
  end
end
