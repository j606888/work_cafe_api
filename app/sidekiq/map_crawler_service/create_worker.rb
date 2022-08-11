class MapCrawlerService::CreateWorker
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(user_id, lat, lng, radius)
    MapCrawlerService::Create.call(
      user_id: user_id,
      lat: lat,
      lng: lng,
      radius: radius
    )
    puts "Done"
  end
end
