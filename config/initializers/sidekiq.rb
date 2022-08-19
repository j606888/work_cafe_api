Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'work_cafe_api' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'work_cafe_api' }
end
