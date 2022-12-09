# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
# Represents essential Repo information for API output
module CafeMap
  module Representer
    # Represent a Project entity as Json
    class Store < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :info_id
      property :place_id
      property :name
      property :formatted_address
      property :location_lat
      property :location_lng
      property :rating
      property :user_ratings_total
    end
  end
end
