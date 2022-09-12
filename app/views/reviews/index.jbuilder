json.reviews do
  json.array!(reviews) do |review|
    json.partial! 'item', review: review
    json.store do
      json.partial! 'stores/item', store: review.store
    end
  end
end

json.partial! 'layouts/paging', resources: reviews
