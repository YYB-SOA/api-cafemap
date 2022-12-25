# frozen_string_literal: true

require 'dry/transaction'

module CafeMap
  module Service
    # Transaction to store cafe data from CafeNomad API to database
    class Update_cluster
      include Dry::Transaction

      step :get_city
      step :get_info
      step :check_unrecorded
      step :store_info

      private

      def get_city(input)
        if input.success?
          Success(city: input[:city_name])
        else
          Failure("City #{input.errors.messages.first}")
        end
      end

      def get_info(input)
        if (filtered_cafe = cafe_from_cafenomad(input))
          input[:filtered_infos_data] = filtered_cafe
        end
        Success(input)
      rescue StandardError => e
        Failure(e.to_s)
      end

      def check_unrecorded(input)
        # Make sure the name of store is in the cafemap community to save the money
        lock = 1
        if (info = input[:filtered_infos_data][0..lock])
          info_allname = Repository::For.klass(Entity::Info).all_name
          input[:info_unrecorded] = info.reject { |each_info| info_allname.include? each_info.name }
        end

        Success(input)
      rescue StandardError => e
        Failure('Something wrong happened when getting unrecorded info')
      end

      def store_info(input)
        info_unrecorded = input[:info_unrecorded] # key: info_unrecorded, value -> entity array, each entity is a entity

        info_unrecorded.each do |each_unrecorded|
          connect_database(each_unrecorded).create(each_unrecorded)
          place_entity = CafeMap::Place::StoreMapper.new(App.config.PLACE_TOKEN,
                                                         [each_unrecorded.name]).load_several
          connect_database(place_entity[0]).create(place_entity[0], each_unrecorded.name)


          last_infoid = connect_database(each_unrecorded).last_id
          last_store = connect_database(place_entity[0]).last

          last_store.update(info_id: last_infoid)
        end
        Success(info_unrecorded)
      rescue StandardError => e
        Failure("Having trouble in building database. #{e} ")
      end

      def cafe_from_cafenomad(input)
        infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
        infos_data.select { |filter| filter.address.include? input[:city] }.shuffle
      rescue StandardError => e
        raise "Could not find that city on CafeNomad #{e}"
      end

      def connect_database(entity)
        Repository::For.entity(entity)
      end
    end
  end
end
