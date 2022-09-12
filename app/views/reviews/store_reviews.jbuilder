json.reviews do
  json.array!(reviews) do |review|
    json.partial! 'item', review: review
  end
end

json.partial! 'layouts/paging', resources: reviews
