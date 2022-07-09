require 'google_map_place'

GoogleMapPlace.configure do |config|
  config.api_key = ENV['GOOGLE_MAP_API_KEY']
end
