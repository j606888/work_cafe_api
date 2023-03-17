json.users do
  json.array!(users) do |user|
    json.partial! 'users/item', user: user
    json.reviews_count user.reviews_count
  end
end

json.partial! 'layouts/paging', resources: users
