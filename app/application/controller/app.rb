# # frozen_string_literal: true

require 'roda'

module CafeMap
  # Web App
  class App < Roda
    route do |r|
      # GET /
      r.root do
        'Home'
      end

      # GET /about
      r.get 'about' do
        'About'
      end

      # GET /post/2011/02/16/hello
      r.get 'post', Integer, Integer, Integer, String do |year, month, day, slug|
        "#{year}-#{month}-#{day} #{slug}" #=> "2011-02-16 hello"
      end

      # GET /username/foobar branch
      r.on 'username', String, method: :get do |username|
        user = User.find_by_username(username)

        # GET /username/foobar/posts
        r.is 'posts' do
          # You can access user here, because the blocks are closures.
          "Total Posts: #{user.posts.size}" #=> "Total Posts: 6"
        end

        # GET /username/foobar/following
        r.is 'following' do
          user.following.size.to_s #=> "1301"
        end
      end

      # /search?q=barbaz
      r.get 'search' do
        "Searched for #{r.params['q']}" #=> "Searched for barbaz"
      end

      r.is 'login' do
        # GET /login
        r.get do
          'Login'
        end

        # POST /login?user=foo&password=baz
        r.post do
          "#{r.params['user']}:#{r.params['password']}" #=> "foo:baz"
        end
      end
    end
  end
end
#   class App < Roda
#     plugin :halt
#     plugin :flash
#     plugin :all_verbs
#     plugin :common_logger, $stderr
#     plugin :status_handler

#     # use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

#     route do |routing|
#       response['Content-Type'] = 'text/html; charset=utf-8'

#       # GET /
#       routing.root do
#         message = "CafeMap API v1 at /region/ in #{App.environment} mode"

#         result_response = Representer::HttpResponse.new(
#           Response::ApiResult.new(status: :ok, message:)
#         )

#         response.status = result_response.http_status_code
#         result_response.to_json
#       end
#       routing.on 'api/v1' do
#         routing.on 'cafemap' do
#           routing.on 'randomstore', String do |city|
#             routing.is do
#               puts "123"
#               # post api/v1/cafemap/randomstore/{city}
#               routing.post do
#                 filtered_info = Service::MiningInfo.new.call(city:)
#                 if filtered_info.failure?
#                   failed = Representer::HttpResponse.new(filtered_info.failure)
#                   routing.halt failed.http_status_code, failed.to_json
#                 end

#                 # Get Obj array
#                 google_data = Service::MiningStore.new.call(city)
#                 if google_data.failure?
#                   failed = Representer::HttpResponse.new(google_data.failure)
#                   routing.halt google_data.http_status_code, google_data.to_json
#                 end

#                 Representer::InfosList.new(filtered_info.value!.message).to_json
#                 Representer::StoresList.new(google_data.value!.message).to_json
#               end
#             end
#           end
#           routing.is do
#             # Get /api/v1/cafemap?city={city}
#             routing.get do
#               city_request = Request::EncodedCityName.new(routing.params)
#               filtered_cafelist = Service::MiningCafeList.new.call(city_request:)
#               if filtered_cafelist.failure?
#                 failed = Representer::HttpResponse.new(filtered_cafelist.failure)
#                 routing.halt failed.http_status_code, failed.to_json
#               end

#               http_response = Representer::HttpResponse.new(filtered_cafelist.value!)
#               response.status = http_response.http_status_code
#               Representer::CafeList.new(filtered_cafelist.value!.message).to_json
#             end
#           end
#         end
#       end
#     end
#   end
# end
