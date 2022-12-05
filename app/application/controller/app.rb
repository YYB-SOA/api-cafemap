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

    status_handler(404) do
      view('404')
    end

    route do |routing|
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        message = "CafeMap API v1 at /region/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message) 
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      # get /region/city

      routing.on 'region' do
        routing.on String do |city|
          routing.get do
            begin
              filtered_info = CafeMap::Database::InfoOrm.where(city:).all
              if filtered_info.nil?
                flash[:error] = 'ArgumentError:nil obj returned. \n -- No cafe shop in the region-- \n'
                routing.redirect '/'
              end
            rescue StandardError => e
              flash[:error] = "ERROR TYPE: #{e}-- Having trouble accessing database--"
              routing.redirect '/'
            end
            filtered_info = CafeMap::Database::InfoOrm.where(city:).all
            # Get Obj array
            google_data = filtered_info.map{|x| x.store[0]} 
            # google_data = filtered_info.map(&:store[]) # datatype question
            Representer::InfosList.new(filtered_info).to_json
            Representer::StoresList.new(google_data).to_json
          end
        end

        routing.is do
          # POST /region/
          routing.post do
            city_request = Forms::NewCity.new.call(routing.params)
            info_made = Service::AddCafe.new.call(city_request)
            if info_made.failure?
              flash[:error] = info_made.failure
              routing.redirect '/'
            end
            info = info_made.value!
            session[:city].insert(0, info[1]).uniq!
            routing.redirect "region/#{info[0].city}"
          end
        end

        routing.on String do |city|
          routing.delete do
            session[:city].delete(city)
          end
          # GET /cafe/region
          routing.get do
            begin
              filtered_info = CafeMap::Database::InfoOrm.where(city:).all
              if filtered_info.nil?
                flash[:error] = 'ArgumentError:nil obj returned. \n -- No cafe shop in the region-- \n'
                routing.redirect '/'
              end
            rescue StandardError => e
              flash[:error] = "ERROR TYPE: #{e}-- Having trouble accessing database--"
              routing.redirect '/'
            end

            # Get Obj array
            google_data = filtered_info.map(&:store)

            # Get Value object
            infostat = Views::StatInfos.new(filtered_info)
            storestat = Views::StatStores.new(google_data)

            view 'region', locals: { infostat:,
                                     storestat: }

          rescue StandardError => e
            puts e.full_message
          end
        end
      end

      routing.on 'map' do
        routing.get do
          result = CafeMap::Service::AppraiseCafe.new.call
          if result.failure?
            flash[:error] = result.failure
          else
            infos_data = result.value!
          end
          ip = CafeMap::UserIp::Api.new.ip
          location = CafeMap::UserIp::Api.new.to_geoloc
          view 'map', locals: { info: infos_data,
                                ip:,
                                your_lat: location[0],
                                your_long: location[1] }
        end
      end
    end
  end
end
