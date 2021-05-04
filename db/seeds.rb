# coding: utf-8

User.create!( name: "管理者",
              email: "admin@email.com",
              password: "password",
              password_confirmation: "password",
              admin: true)
User.create!( name: "上長A",
              email: "superior-a@email.com",
              password: "password",
              password_confirmation: "password",
              affiliation: "管理部",
              employee_number: "1",
              uid: "1",
              superior: true)
User.create!( name: "上長B",
              email: "superior-b@email.com",
              password: "password",
              password_confirmation: "password",
              affiliation: "管理部",
              employee_number: "2",
              uid: "2",
              superior: true)
User.create!( name: "一般",
              email: "sample@email.com",
              password: "password",
              password_confirmation: "password",
              affiliation: "技術部",
              employee_number: "3",
              uid: "3",
              )
              
# 60.times do |n|
#   name  = Faker::Name.name
#   email = "sample-#{n+1}@email.com"
#   password = "password"
#   User.create!(name: name,
#                email: email,
#                password: password,
#                password_confirmation: password)
# end