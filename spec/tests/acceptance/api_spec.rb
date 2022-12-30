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
  #   CafeMap::Repository::RepoStore.wipe
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
    # before do
    #   DatabaseHelper.wipe_database
    # end

    it 'HAPPY: should be able to find and save remote data into to db' do
      # WHEN: the service is called with the request form object
      city_request = CafeMap::Request::EncodedCityName.new({"city"=>"南投"})
      puts "city_request.city: #{city_request.uncode_cityname}"
      outputs = CafeMap::Service::AddCafe.new.call(city_request: city_request)

      # puts "outputs: #{outputs}"
      # encoded_city = CGI.escape(city_request.uncode_cityname)


      # puts "\n\n CGI encoded_city: #{encoded_city}\n\n"
      puts "\n\n Monad encoded_city: #{city_request.call}\n\n"
      puts "\n\n Monad encoded_city: #{city_request.call.value!}\n\n"
      puts "\n\n Monad encoded_city: #{city_request.call.value!.class}\n\n"
      puts "\n\n Condition: #{city_request.call.value! == "南投"}\n\n"
      city_ta = city_request.call.value!
      url_utf8 = "/api/v1/cafemap/random_store?city=#{city_ta}".encode('UTF-8', invalid: :replace, undef: :replace, replace: '\uFFFD')
      encoded_url = url_utf8.encode('ASCII', invalid: :replace, undef: :replace, replace: '?')

      post encoded_url
      puts "\n\n last_response: #{last_response}\n\n"
      _(last_response.status).must_equal 202

      # # Then this 2 stores supposed to be exist in database
      # info_orm = CafeMap::Repository::Infos

      # # THEN: the result should report success..
      # _(store_made.success?).must_equal true

      # # ..and provide a info entity with the right details
      # rebuilt = store_made.value!
      # includeChecker(rebuilt, :name, info_orm.all_name)
      # includeChecker(rebuilt, :latitude, info_orm.all_latitude)
      # includeChecker(rebuilt, :longitude, info_orm.all_longitude)
      # includeChecker(rebuilt, :address, info_orm.all_address)
    end
  end

  # describe 'Appraise cafe shop searching route' do
  #     describe 'Retrieve and store place_api data' do
  #   before do
  #     DatabaseHelper.wipe_database
  #   end

  #   it 'HAPPY: should be able to find and save remote data into to db' do
  #     # WHEN: the service is called with the request form object
  #     city_request = CafeMap::Forms::NewCity.new.call(city_name: CITY_DEFAULT)
  #     store_made = CafeMap::Service::AddCafe.new.call(city_request)

  #     # Then this 2 stores supposed to be exist in database
  #     info_orm = CafeMap::Repository::Infos # nothing return

  #     # THEN: the result should report success..
  #     _(store_made.success?).must_equal true

  #     # ..and provide a info entity with the right details
  #     rebuilt = store_made.value!
  #     includeChecker(rebuilt, :name, info_orm.all_name)
  #     includeChecker(rebuilt, :latitude, info_orm.all_latitude)
  #     includeChecker(rebuilt, :longitude, info_orm.all_longitude)
  #     includeChecker(rebuilt, :address, info_orm.all_address)
  #   end
  # end
  #     it 'should be able to appraise a project subfolder' do
        # CafeMap::Service::AddCafe.new.call(
        #   owner_name: USERNAME, project_name: PROJECT_NAME
        # )
  
        # get "/api/v1/projects/#{USERNAME}/#{PROJECT_NAME}/spec"
        # _(last_response.status).must_equal 202
  
        # 5.times { sleep(1); print '.' }
  
        # get "/api/v1/projects/#{USERNAME}/#{PROJECT_NAME}/spec"
        # _(last_response.status).must_equal 200
        # appraisal = JSON.parse last_response.body
        # _(appraisal.keys.sort).must_equal %w[folder project]
        # _(appraisal['project']['name']).must_equal PROJECT_NAME
        # _(appraisal['project']['owner']['username']).must_equal USERNAME
        # _(appraisal['project']['contributors'].count).must_equal 3
        # _(appraisal['folder']['path']).must_equal 'spec'
        # _(appraisal['folder']['subfolders'].count).must_equal 1
        # _(appraisal['folder']['line_count']).must_equal 151
        # _(appraisal['folder']['base_files'].count).must_equal 3
      # end
  
      # it 'should be report error for an invalid subfolder' do
    #     CodePraise::Service::AddProject.new.call(
    #       owner_name: USERNAME, project_name: PROJECT_NAME
    #     )
  
    #     get "/api/v1/projects/#{USERNAME}/#{PROJECT_NAME}/foobar"
    #     _(last_response.status).must_equal 202
    #     5.times { sleep(1); print '.' }
  
    #     get "/api/v1/projects/#{USERNAME}/#{PROJECT_NAME}/foobar"
    #     _(last_response.status).must_equal 404
    #     _(JSON.parse(last_response.body)['status']).must_include 'not'
    #   end
  
    #   it 'should be report error for an invalid project' do
    #     CodePraise::Service::AddProject.new.call(
    #       owner_name: '0u9awfh4', project_name: 'q03g49sdflkj'
    #     )
  
    #     get "/api/v1/projects/#{USERNAME}/#{PROJECT_NAME}/foobar"
    #     _(last_response.status).must_equal 404
    #     _(JSON.parse(last_response.body)['status']).must_include 'not'
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
end