class Approval < ApplicationRecord
  belongs_to :user

  validates :month_superior, presence: true
  validates :checkbox, acceptance: true

  # scope :next_day1, -> { where(next_day: true).(month_superior: "上長A")}
  # scope :next_day2, -> { where(next_day: true).(month_superior: "上長B")}
  # scope :next_day3, -> { where(next_day: true).(instructor_confirmation: "申請中")}
  
  # Ex:- scope :active, -> {where(:active => true)}
  # scope :month_superior, -> { where(month_superior: "上長A") : where(month_superior: "上長B")}
  # scope :instructor_confirmation, -> { where(instructor_confirmation: "申請中")}
  # # Ex:- scope :active, -> {where(:active => true)}  
  

end
