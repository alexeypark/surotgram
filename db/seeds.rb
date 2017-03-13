# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([{ user_name: 'alexey', email: 'alexey@mail.com', password: 'password', avatar: Faker::Avatar.image }])
50.times do
  User.create([{ user_name: Faker::Internet.user_name, email: Faker::Internet.free_email, password: 'password'}])
end

users = User.all
user  = users.first
following = users[10..51]
followers = users[2..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

20.times do
  Post.create([{caption: Faker::Lorem.sentence(4), image: File.open(Dir.glob(File.join(Rails.root, 'sampleimages', '*')).sample), user_id: following.sample.id }])
end