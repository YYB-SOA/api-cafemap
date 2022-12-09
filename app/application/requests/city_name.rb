# frozen_string_literal: true

require 'base64'
require 'dry/monads'
require 'json'

module CafeMap
  module Request
    # Project list request parser
    class EncodedCityName
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming list requests
      def call
        Success(
          JSON.parse(decode(@params['city'])) # perhaps should be modify next week
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'City name is not found.'
          )
        )
      end

      # Decode params
      def decode(param)
        Base64.urlsafe_decode64(param)
      end

    end
  end
end