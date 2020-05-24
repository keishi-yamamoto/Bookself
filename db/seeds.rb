require 'faker'

10.times do
  user = User.create!(
    name: Faker::Internet.unique.username,
    email: Faker::Internet.unique.email,
    password: Faker::Internet.password,
    elastic_id: Faker::Alphanumeric.alphanumeric(number: 10),
    created_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
  )
  puts "#{user.name} has been created."
end