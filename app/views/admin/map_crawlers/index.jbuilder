json.map_crawlers do
  json.array!(map_crawlers) do |map_crawler|
    json.(map_crawler, :id, :name, :place_id, :lat, :lng, :source_data)
    json.status map_crawler.aasm_state
  end
end

json.partial! 'layouts/paging', resources: map_crawlers
