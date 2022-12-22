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
          Base64.decode64(@params['city']).force_encoding('UTF-8')
          # decode(@params)# perhaps should be modify next week
        )
      end
    rescue StandardError => e
      Failure(
        Response::ApiResult.new(
          status: :bad_request,
          message: e
        )
      )
    end

    # Decode params
    def decode(param)
      Base64.urlsafe_decode64(param)
    end
  end
end
