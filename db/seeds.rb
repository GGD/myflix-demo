# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: 'TV Commedies')
Category.create(name: 'TV Dramas')

monk = Video.create(title: 'Monk', description: 'Moooonk', large_cover: '/tmp/monk_large.jpg', small_cover: '/tmp/monk.jpg', category_id: '1')
Video.create(title: 'SouthPark', description: 'south_park', large_cover: '/tmp/south_pard.jpg', small_cover: '/tmp/south_park.jpg', category_id: '2')

ggd = User.create(email: 'ggd@example.com', password: '1234', full_name: 'Ga Dii')

Review.create(user: ggd, video: monk, rating: 5, content: 'Awesome!')
Review.create(user: ggd, video: monk, rating: 2, content: 'soso movie')