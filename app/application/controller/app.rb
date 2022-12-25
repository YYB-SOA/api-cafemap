# frozen_string_literal: true

require 'roda'
require 'slim/include'
require 'descriptive_statistics'

module CafeMap
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets', css: 'style.css', js: 'table_row.js'
    plugin :common_logger, $stderr
    plugin :halt
    plugin :all_verbs
    plugin :status_handler
    plugin :flash

    # use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    status_handler(404) do
      view('404')
    end

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      routing.public

      # GET /
      routing.root do
        session[:city] ||= []

        # Load previously viewed location
        result = Service::ListCities.new.call
        if result.failure?
          flash[:error] = result.failure
        else
          cities = result.value!
          flash.now[:notice] = 'Add a city name to get started' if cities.none?
          session[:city] = cities.map(&:city)
        end

        view 'home'
      end

      routing.on 'region' do
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


            # Update cluster output



            # Get Value object
            
            # cluster_data_in_db = ???
            # clusterstat = Views::StatStores.new(cluster_data_in_db)
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
