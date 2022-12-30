# frozen_string_literal: true
require "json"
require 'roar/decorator'
require 'roar/json'
# Represents essential Repo information for API output
# module CafeMap
#   module Representer
#     # Represent a Project entity as Json
#     class Cluster < Roar::Decorator
#       include Roar::JSON
#       include Roar::Hypermedia
#       include Roar::Decorator::HypermediaConsumer

#       property      :infoid
#       property      :name
#       property      :city
#       property      :wifi
#       property      :seat
#       property      :quiet
#       property      :tasty
#       property      :cheap
#       property      :music
#       property      :url
#       property      :address
#       property      :latitude
#       property      :longitude
#       property      :limited_time
#       property      :socket
#       property      :standing_desk
#       property      :mrt
#       property      :open_time
#       property      :info_id
#       property      :place_id
#       # property      :name
#       property      :formatted_address
#       property      :business_status
#       property      :location_lat
#       property      :location_lng
#       property      :viewport_ne_lat
#       property      :viewport_ne_lng
#       property      :viewport_sw_lat
#       property      :viewport_sw_lng
#       property      :compound_code
#       property      :global_code
#       property      :rating
#       property      :user_ratings_total
#       property      :types
#       property      :cluster
#     end
#   end
# end
# frozen_string_literal: true

# require 'roar/decorator'
# require 'roar/json'
# # Represents essential Repo information for API output
# module CafeMap
#   module Representer
#     # Represent a Project entity as Json
#     class Info < Roar::Decorator
#       include Roar::JSON
#       include Roar::Hypermedia
#       include Roar::Decorator::HypermediaConsumer
      
#       property      :infoid
#       property      :name
#       property      :city
#       property      :wifi
#       property      :seat
#       property      :quiet
#       property      :tasty
#       property      :cheap
#       property      :music
#       property      :url
#       property      :address
#       property      :latitude
#       property      :longitude
#       property      :limited_time
#       property      :socket
#       property      :standing_desk
#       property      :mrt
#       property      :open_time
#     end
#   end
# end

# # frozen_string_literal: true

# def require_app(folders = %w[infrastructure domain presentation application])
#     app_list = Array(folders).map { |folder| "app/#{folder}" }
#     full_list = ['config', app_list].flatten.join(',')
  
#     Dir.glob("./{#{full_list}}/**/*.rb").each do |file|
#       require file
#     end
#   end

# require_app
# a = CafeMap::Database::InfoOrm.first
# puts a.infoid
# b = Struct.new(:info)
# b.new(a)
# puts b["infoid"]
# CafeMap::Representer::Info.new(b).to_json
# a = { 'id' => 39, 'infoid' => 'aa029a72-e7e9-4c65-9d80-e3bf2e488170', 'name' => 'COCO鬆餅屋', 'city' => 'changhua', 'wifi' => '4',
# 'seat' => '1', 'quiet' => '1', 'tasty' => '4', 'cheap' => '3', 'music' => '3', 'url' => 'https://www.facebook.com/cocoffee579/?fref=ts', 'address' => '彰化縣員林鎮中正路581號', 'latitude' => '23.96121200', 'longitude' => '120.57134000', 'limited_time' => '', 'socket' => '', 'standing_desk' => '', 'mrt' => '', 'open_time' => '10:30 - 21:30', 'info_id' => 49, 'place_id' => 'ChIJN8xHSlg2aTQRBtxatsnzcpw', 'formatted_address' => '510台灣彰化縣員林市中正路581號', 'business_status' => 'OPERATIONAL', 'location_lat' => '23.9612054', 'location_lng' => '120.5713114', 'viewport_ne_lat' => '23.96257232989272', 'viewport_ne_lng' => '120.5727422798927', 'viewport_sw_lat' => '23.95987267010728', 'viewport_sw_lng' => '120.5700426201073', 'compound_code' => 'XH6C+FG 員林市 彰化縣', 'global_code' => '7QM2XH6C+FG', 'rating' => 4.3, 'user_ratings_total' => 611, 'types' => '["cafe", "food", "point_of_interest", "establishment"]', 'cluster' => 1 }
# album = Struct.new(:clusters)
# b.new(a)
# puts b
# puts CafeMap::Representer::Cluster.new(b).to_json