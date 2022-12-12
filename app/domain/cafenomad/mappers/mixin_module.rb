# frozen_string_literal: true

# Using mixin to avoid rubocop show "Too many method inside a class"
module InfoMixinGeo
  # Infos about  geometry infomration except rank
  def infoid
    @data['id']
  end

  def name
    @data['name']
  end

  def city
    @data['city']
  end

  def url
    @data['url']
  end

  def address
    @data['address']
  end

  def latitude
    @data['latitude']
  end

  def longitude
    @data['longitude']
  end

  def limited_time
    @data['limited_time']
  end

  def socket
    @data['socket']
  end

  def standing_desk
    @data['standing_desk']
  end

  def mrt
    @data['mrt']
  end

  def open_time
    @data['open_time']
  end
end

# Using mixin to avoid rubocop show "Too many method inside a class"
module InfoMixinRank
  # Infos about  rank
  def wifi
    @data['wifi']
  end

  def seat
    @data['seat']
  end

  def quiet
    @data['quiet']
  end

  def tasty
    @data['tasty']
  end

  def cheap
    @data['cheap']
  end

  def music
    @data['music']
  end
end

# Using mixin to avoid rubocop show "Too many method inside a class"
# module StoreMixinAll
#   # Infos about  rank
#   def place_id
#     @data['place_id']
#   end

#   def name
#     @data['name']
#   end

#   def formatted_address
#     @data['formatted_address']
#   end

#   def location_lat
#     @data['geometry']['location']['lat']
#   end

#   def location_lng
#     @data['geometry']['location']['lng']
#   end

#   # BELOW: Addition information for GDSC-----
#   def viewport_ne_lat
#     @data['geometry']['viewport']['northeast']['lat']
#   end

#   def viewport_ne_lng
#     @data['geometry']['viewport']['northeast']['lng']
#   end

#   def viewport_sw_lat
#     @data['geometry']['viewport']['southwest']['lat']
#   end

#   def viewport_sw_lng
#     @data['geometry']['viewport']['southwest']['lng']
#   end

#   def global_code
#     @data['plus_code']['global_code']
#   end

#   def compound_code
#     @data['plus_code']['compound_code']
#   end

#   def types
#     @data['types']
#   end
#   # ABOVE: Addition information for GDSC------

#   def rating
#     @data['rating']
#   end

#   def user_ratings_total
#     @data['user_ratings_total']
#   end
end
