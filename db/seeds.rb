# coding: utf-8

user = User.create!( name: "管理者",
              email: "admin@email.com",
              password: "password",
              password_confirmation: "password",
              admin: true)
# user.approvals.create!(
#               month_superior: "上長A",
#               one_month: "2021-04-01",
#               instructor_confirmation: "申請中")
# user.approvals.create!(
#               month_superior: "上長B",
#               one_month: "2021-04-01",
#               instructor_confirmation: "申請中")
# attendance = user.attendances.create(user_id: "1",
#   # started_at: "2021-04-30-10:00:00",
#   # finished_at: "2021-04-30-10:00:00"
# )
# attendance.approvals.create(attendance_id: "1",
#               # one_month: '2021-05-01',
#               month_superior: "上長A",
#               instructor_confirmation: "申請中")
User.create!( name: "上長A",
              email: "superior-a@email.com",
              password: "password",
              password_confirmation: "password",
              affiliation: "管理部",
              employee_number: "1",
              uid: "1",
              superior: true)
# attendance = user.attendances.create(user_id: "2")
# attendance.approvals.create(attendance_id: "2",
#               # one_month: '2021-04-01',
#               month_superior: "上長A",
#               instructor_confirmation: "申請中")
User.create!( name: "上長B",
              email: "superior-b@email.com",
              password: "password",
              password_confirmation: "password",
              affiliation: "管理部",
              employee_number: "2",
              uid: "2",
              superior: true)
# attendance = user.attendances.create(user_id: "3")
# attendance.approvals.create(attendance_id: "3",
#               # one_month: '2021-05-01',
#               month_superior: "上長B",
#               instructor_confirmation: "申請中")
              
User.create!( name: "一般",
              email: "sample@email.com",
              password: "password",
              password_confirmation: "password",
              affiliation: "技術部",
              employee_number: "3",
              uid: "3",
              )
# attendance = user.attendances.create(user_id: "4")
# attendance.approvals.create(attendance_id: "4",
#               # one_month: '2021-04-01',
#               month_superior: "上長B",
#               instructor_confirmation: "申請中")
              
Office.create!(
  user_id: "1",
  number: "1",
  name: "拠点A",
  category: "出勤",
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