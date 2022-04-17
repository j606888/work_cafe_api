json.map_urls do
  json.array!(map_urls) do |map_url|
    json.(map_url, :id, :user_id, :url, :keyword, :place_id, :created_at, :updated_at)
    json.status map_url.aasm_state
  end
end

json.partial! 'layouts/paging', resources: map_urls
