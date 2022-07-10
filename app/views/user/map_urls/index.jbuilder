json.map_urls do
  json.array!(map_urls) do |map_url|
    json.(map_url, :id, :url, :keyword, :decision, :place_id, :created_at, :updated_at)
  end
end

json.partial! 'layouts/paging', resources: map_urls
