# frozen_string_literal: true

require 'dry/transaction'

module CafeMap
  module Service
    # Transaction to store cafe data from CafeNomad API to database
    class MiningInfo
      include Dry::Transaction

      step :validate_city
      step :get_info_from_db

      DB_ERR = 'There is something in database.'

      def validate_city(input)
        city_request = input[:city_request].call
        if city_request.success?
          Success(input.merge(city: city_request.value!))
        else
          Failure(city_request.failure)
        end
      end

      def get_info_from_db(input)
        CafeMap::Database::InfoOrm.where(city: input[:city])
          .then { |info| CafeMap::Response::InfoList.new(info) }
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
      end
    rescue StandardError
      Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
    end
  end
end
