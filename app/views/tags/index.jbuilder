json.array!(tags) do |tag|
  json.(tag, :id, :name, :primary)
end
