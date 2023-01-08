# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/acceptance_helper'
require 'cgi'
require 'rack/test'

def app
  CafeMap::App
end

describe 'Test API routes' do
  include Rack::Test::Methods
  # VcrHelper.setup_vcr

  # before do
  #   VcrHelper.configure_vcr_for_cafe
  #   DatabaseHelper.wipe_database
  #   CafeMap::Repository::InfoStore.wipe
  # end

  # after do
  #   VcrHelper.eject_vcr
  # end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200
      body = JSON.parse(last_response.body)

      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Retrieve and cafenomad data' do
    before do
      DatabaseHelper.wipe_database
    end
    it 'HAPPY: should be able to find and save remote data into to db' do
      # # WHEN: the service is called with the request form object
      abc = PARAMS_DEFAULT.dup
      city_request = CafeMap::Request::EncodedCityName.new(abc)

      puts "CH City Name: #{city_request.dup.uncode_cityname}"

      store_made = CafeMap::Service::AddCafe.new.call(city_request: city_request)
      puts "outputs: #{outputs}"
      
      url_encoded_string = CGI.escape(city_request.call.value!)
      puts "\n\nurl_encoded_string: #{url_encoded_string}"

      # post "/api/v1/cafemap/random_store?city=#{url_encoded_string}"

      # _(last_response.status).must_equal 200
      # body = JSON.parse last_response.body
      # 3.times { sleep(1) and print('.') }

      # _(body.keys.sort).must_equal %w[infos stores]
      # _(body['infos'].length).must_be :>, 1
      # _(body['stores'].length).must_be :>, 1

      # name_array = body['stores'].map { |store| store['name'] }
      # puts "\n\nname_array:\n#{name_array}"
      # expect(!(name_array.all? { |str| !str.nil? }))

      # # Testing all data's compund code end with  南投
      # compound_array = body['stores'].map { |store| store['compound_code'] }
      # result = compound_array.all? do |s|
      #   s.include?(test_city) || (warn "Warming: compound_code does not match the condition: #{s}"
      #                             break false)
      # end
      # expect(result).must_equal true

      # # Testing first data's formatted_address includes  南投
      # formatted_address = body['stores'].map { |store| store['formatted_address'] }
      # result = formatted_address.all? do |s|
      #   s.include?(test_city) || (warn "Warming: formatted_address does not match the condition: #{s}"
      #                             break false)
      # end
      # expect(result).must_equal true
    end
  end

  # describe 'Cafe shop searching route' do
  #   describe 'Retrieve and store both placeAIP and CafeNomad data with binding in order' do
  #     # before do
  #     #   DatabaseHelper.wipe_database
  #     # end
  #     it 'HAPPY: should be able to find and save remote INFO data into to db' do
  #       # WHEN: the service is called with the request form object
  #       info_orm = CafeMap::Repository::Infos
  #       # Name must be String
  #       all_name = info_orm.all_name.map { |info| info.must_be_kind_of String }
  #       all_name.all?.must_equal true

  #       # last id must exist and should be a integer
  #       info_orm.last_id.is_a?(Integer).must_equal true

  #       # Rating must be string
  #       arrays = [info_orm.all_quiet, info_orm.all_cheap, info_orm.all_music, info_orm.all_tasty, info_orm.all_wifi]
  #       assert arrays.all? { |array| array.all? { |info| info.is_a? String } }
  #     end

########################## stores
      # it 'HAPPY: should be able to find and save remote STORE data into to db' do
      #   # WHEN: the service is called with the request form object
      #   store_orm = CafeMap::Repository::Stores
      #   # Name must be String
      #   all_name = store_orm.all_name.map { |store| store.must_be_kind_of String }
      #   all_name.all?.must_equal true

      #   # last id must exist and should be a integer
      #   store_orm.last_id.is_a?(Integer).must_equal true

        # # Rating must be string
        # arrays = [info_orm.all_quiet, info_orm.all_cheap, info_orm.all_music, info_orm.all_tasty, info_orm.all_wifi]
        # assert arrays.all? { |array| array.all? { |info| info.is_a? String } }
        # THEN: the result should report success..
        # _(store_made.success?).must_equal true

        # # ..and provide a info entity with the right details
        # rebuilt = store_made.value!
        # includeChecker(rebuilt, :name, info_orm.all_name)
        # includeChecker(rebuilt, :latitude, info_orm.all_latitude)
        # includeChecker(rebuilt, :longitude, info_orm.all_longitude)
        # includeChecker(rebuilt, :address, info_orm.all_address)
      # end
    # end
  # end
end


# it 'should be report error for an invalid cityname' do
  #   CafeMap::Service::AddCafe.new.call()

  #   get "/api/v1/cafemap/#{USERNAME}/clusters?city=#{chinese_city}"
  #   _(last_response.status).must_equal 202
  #   5.times { sleep(1); print '.' }

  #   get "/api/v1/cafemap/#{USERNAME}/#{PROJECT_NAME}/foobar"
  #   _(last_response.status).must_equal 404
  #   _(JSON.parse(last_response.body)['status']).must_include 'not'
  # end

  # it 'should be report error for an invalid project' do
  #   CodePraise::Service::AddProject.new.call(
  #     owner_name: '0u9awfh4', project_name: 'q03g49sdflkj'
  #   )

  #   get "/api/v1/projects/#{USERNAME}/#{PROJECT_NAME}/foobar"
  #   _(last_response.status).must_equal 404
  #   _(JSON.parse(last_response.body)['status']).must_include 'not'
#   end
# end

# describe 'Add projects route' do
#   it 'should be able to add a project' do
# post "api/v1/projects/#{USERNAME}/#{PROJECT_NAME}"

# _(last_response.status).must_equal 201

# project = JSON.parse last_response.body
# _(project['name']).must_equal PROJECT_NAME
# _(project['owner']['username']).must_equal USERNAME

# proj = CodePraise::Representer::Project.new(
#   CodePraise::Representer::OpenStructWithLinks.new
# ).from_json last_response.body
# _(proj.links['self'].href).must_include 'http'
# end

# it 'should report error for invalid projects' do
# post 'api/v1/projects/0u9awfh4/q03g49sdflkj'

# _(last_response.status).must_equal 404

# response = JSON.parse(last_response.body)
# _(response['message']).must_include 'not'
#   end
# end

# describe 'Get projects list' do
#   it 'should successfully return project lists' do
#     CodePraise::Service::AddProject.new.call(
#       owner_name: USERNAME, project_name: PROJECT_NAME
#     )

#     list = ["#{USERNAME}/#{PROJECT_NAME}"]
#     encoded_list = CodePraise::Request::EncodedProjectList.to_encoded(list)

#     get "/api/v1/projects?list=#{encoded_list}"
#     _(last_response.status).must_equal 200

#     response = JSON.parse(last_response.body)
#     projects = response['projects']
#     _(projects.count).must_equal 1
#     project = projects.first
#     _(project['name']).must_equal PROJECT_NAME
#     _(project['owner']['username']).must_equal USERNAME
#     _(project['contributors'].count).must_equal 3
#   end

#   it 'should return empty lists if none found' do
#     list = ['djsafildafs;d/239eidj-fdjs']
#     encoded_list = CodePraise::Request::EncodedProjectList.to_encoded(list)

#     get "/api/v1/projects?list=#{encoded_list}"
#     _(last_response.status).must_equal 200

#     response = JSON.parse(last_response.body)
#     projects = response['projects']
#     _(projects).must_be_kind_of Array
#     _(projects.count).must_equal 0
#   end

#   it 'should return error if not list provided' do
#     get '/api/v1/projects'
#     _(last_response.status).must_equal 400

#     response = JSON.parse(last_response.body)
#     _(response['message']).must_include 'list'
#   end
# end
# end
