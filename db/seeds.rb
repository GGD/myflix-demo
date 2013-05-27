# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: 'Monk', description: 'Moooonk', large_cover: '/tmp/monk_large.jpg', small_cover: '/tmp/monk.jpg')
Video.create(title: 'SouthPark', description: 'south_park', large_cover: '/tmp/south_pard.jpg', small_cover: '/tmp/south_park.jpg')