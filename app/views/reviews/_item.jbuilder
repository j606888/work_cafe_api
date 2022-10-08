json.(review, :id, :recommend, :room_volume, :time_limit, :socket_supply, :description)

json.primary_tags do
  tags = review.tags.filter { |tag| tag.primary }.map do |tag|
    tag.name
  end
  json.array! tags
end
json.secondary_tags do
  tags = review.tags.filter { |tag| !tag.primary }.map do |tag|
    tag.name
  end
  json.array! tags
end
json.created_at review.created_at.to_i
