json.users do
  json.array!(users) do |user|
    json.partial! 'users/item', user: user
  end
end

json.partial! 'layouts/paging', resources: users
