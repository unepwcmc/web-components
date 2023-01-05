# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
7.times do |i|
    country = Country.new
    country.iso3 = "I am country-#{i}"
    country.name = "Country#{i}"
    country.attr3 = "attribute#{i}"
    country.attr4 = i + 15
    country.save
end