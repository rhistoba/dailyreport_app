# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_admin = User.create!(
        name: "Example User",
        email: "user@example.com",
        password: "foobar",
        password_confirmation: "foobar",
        admin: true,
        department: 'Management')

User.create!(
    name: "Hoge Hoge",
    email: "hoge@example.com",
    password: "foobar",
    password_confirmation: "foobar",
    admin: false,
    department: 'Development')

98.times do |n|
  name = Faker::Name.name
  email = "user-#{n+1}@example.com"
  password = "password"
  User.create!(
          name: name,
          email: email,
          password: password,
          password_confirmation: password,
          department: 'Development')
end

users = User.order(:created_at).take(10)
users.each do |user|
  date = Time.local(2016,12,31)
  50.times do
    date = date.next_day
    title = Faker::Lorem.sentence(1)
    content = Faker::Lorem.sentence(50)
    user.reports.create!(date: date, title: title, content: content)
  end
end

reports = Report.order(date: :desc).take(30)
reports.each do |report|
  (1..4).each do |i|
    user = i.odd? ? user_admin : report.user
    content = Faker::Lorem.sentence(10)
    user.comments.create!(content: content, report_id: report.id)
  end
end