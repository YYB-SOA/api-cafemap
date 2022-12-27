# # frozen_string_literal: true

require 'roda'

module CafeMap
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :common_logger, $stderr
    plugin :status_handler
    plugin :caching
    # use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    route do |routing|
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        message = "CafeMap API v1 at /region/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message:)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end
      routing.on 'api/v1' do
        routing.on 'cafemap' do
          routing.on 'random_store' do
            # post api/v1/cafemap/random_store?city={city}

            routing.post do
              puts routing.params
              city_req = Request::EncodedCityName.new(routing.params)
              filtered_cafelist = Service::AddCafe.new.call(city_request: city_req)
              if filtered_cafelist.failure?
                failed = Representer::HttpResponse.new(filtered_cafelist.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(filtered_cafelist.value!)
              response.status = http_response.http_status_code
              Representer::CafeList.new(filtered_cafelist.value!.message).to_json
            end

            # routing.is do

            # end
          end
          routing.is do
            # Get /api/v1/cafemap?city={city}
            routing.get do
              # response.cache_control public: true, max_age: 30
              # city_request = Request::EncodedCityName.new(routing.params)
              filtered_cafelist = Service::MiningCafeList.new.call(routing.params)
              if filtered_cafelist.failure?
                failed = Representer::HttpResponse.new(filtered_cafelist.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(filtered_cafelist.value!)
              response.status = http_response.http_status_code
              Representer::CafeList.new(filtered_cafelist.value!.message).to_json
            end
          end

          routing.on 'clusters' do
            # post api/v1/cafemap/random_store?city={city}
            routing.get do
              response.cache_control public: true, max_age: 600

              selected_city = Service::MiningCafeList.new.call(routing.params)

              # if filtered_cafelist.failure?
              #   failed = Representer::HttpResponse.new(filtered_cafelist.failure)
              #   routing.halt failed.http_status_code, failed.to_json
              # end

              # http_response = Representer::HttpResponse.new(filtered_cafelist.value!)
              # response.status = http_response.http_status_code
              # Representer::CafeList.new(filtered_cafelist.value!.message).to_json
            end
          end
        end
      end
    end
end
