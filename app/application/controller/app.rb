# frozen_string_literal: true

require 'roda'

module CafeMap
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :common_logger, $stderr
    plugin :status_handler

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

      # get /region/city

      routing.on 'api/v1' do
        # routing.on 'map' do
        #   routing.get do
        #     result = CafeMap::Service::AppraiseCafe.new.call
        #     if result.failure?
        #       flash[:error] = result.failure
        #     else
        #       infos_data = result.value!
        #     end
        #     ip = CafeMap::UserIp::Api.new.ip
        #     location = CafeMap::UserIp::Api.new.to_geoloc
        #     view 'map', locals: { info: infos_data,
        #                           ip:,
        #                           your_lat: location[0],
        #                           your_long: location[1] }
        #   end
        # end
        routing.on 'cafemap' do
          routing.on 'random_store', String do |city|
            # Get /api/v1/cafemap/random_store/{city}
            routing.post do
              filtered_info = Service::MiningInfo.new.call(city)
              if filtered_info.failure?
                failed = Representer::HttpResponse.new(filtered_info.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              # Get Obj array
              google_data = Service::MiningStore.new.call(city)
              if google_data.failure?
                failed = Representer::HttpResponse.new(google_data.failure)
                routing.halt google_data.http_status_code, google_data.to_json
              end
              
              Representer::InfosList.new(filtered_info.value!.message).to_json
              Representer::StoresList.new(google_data.value!.message).to_json
            end
          end
          routing.is do
            # Get /api/v1/cafemap?city={city}
            routing.get do
              puts ":city -> #{:city}"
              puts ":routing.params -> #{routing.params['city']}" 
              city_request = Request::EncodedCityName.new(routing.params)
              puts ":city_request -> #{city_request}" 
              filtered_info = Service::MiningInfo.new.call(city_request:)
              if filtered_info.failure?
                failed = Representer::HttpResponse.new(filtered_info.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              # Get Obj array
              google_data = Service::MiningStore.new.call(city_request:)
              if google_data.failure?
                failed = Representer::HttpResponse.new(google_data.failure)
                routing.halt google_data.http_status_code, google_data.to_json
              end
              Representer::InfosList.new(filtered_info.value!.message).to_json
              Representer::StoresList.new(google_data.value!.message).to_json
            end
          end
        end
      end
    end
  end
end
