# frozen_string_literal: true

require 'dry/transaction'

module CafeMap
  module Service
    # Transaction to store cafe data from CafeNomad API to database
    class MiningInfo
      include Dry::Transaction

      step :validate_city
      step :get_info_from_db

      DB_ERR = 'There is something wrong in database.'

      def validate_city(input)
        city_request = input[:city_request].call
        city_request.success? ? Success(input.merge(city: city_request.value)) : Failure(city_request.failure)
      rescue StandardError => e
        Failure(error: e, message: 'An error occurred while validating the city')
      end

      def get_info_from_db(input)
        info = CafeMap::Database::InfoOrm.where(city: input[:city])
        list = CafeMap::Response::InfoList.new(info)
        result = Response::ApiResult.new(status: :ok, message: list)
        Success(result)
      rescue StandardError => e
        Failure(error: e, message: 'An error occurred while fetching info from the database')
      end
    end
  end
end
