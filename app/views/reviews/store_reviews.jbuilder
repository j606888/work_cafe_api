json.reviews do
  json.array!(reviews) do |review|
    json.partial! 'item', review: review
    json.user_avatar_url review.user.avatar_url
    json.user_name review.user.name
  end
end

json.partial! 'layouts/paging', resources: reviews
