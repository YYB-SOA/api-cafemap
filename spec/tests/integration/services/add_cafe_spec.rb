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

  describe 'Retrieve and  project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to find and save remote data into to db' do
      # WHEN: the service is called with the request form object
      city_request = CafeMap::Forms::NewCity.new.call(city_name: CITY_DEFAULT)
      store_made = CafeMap::Service::AddCafe.new.call(city_request)

      # Then this 2 stores supposed to be exist in database
      info_orm = CafeMap::Repository::Infos # nothing return

      # THEN: the result should report success..
      _(store_made.success?).must_equal true

      # ..and provide a info entity with the right details
      rebuilt = store_made.value!
      includeChecker(rebuilt, :name, info_orm.all_name)
      includeChecker(rebuilt, :latitude, info_orm.all_latitude)
      includeChecker(rebuilt, :longitude, info_orm.all_longitude)
      includeChecker(rebuilt, :address, info_orm.all_address)
    end
  end
end
