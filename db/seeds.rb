# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

["無限時", "時常有空位", "幾乎無人說話", "有 WiFi", "有插座"].each do |name|
  Tag.create!(name: name, primary: true)
end

["有動物", "提供正餐"].each do |name|
  Tag.create!(name: name, primary: false)
end
