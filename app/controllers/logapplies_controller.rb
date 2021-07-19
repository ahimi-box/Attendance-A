class LogappliesController < ApplicationController
  
  def index
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find_by(user_id: params[:user_id])
    # byebug
    @logs = if params[:year].present? && params[:month].present?
      year_month = Time.new(params[:year],params[:month])
      # 2021-07-01 00:00:00 +0900
      year_month = year_month.to_date
      # byebug
      # selectで選択された年月の承認ログを抽出
      Logapply.where(log_worked_on: year_month.beginning_of_month..year_month.end_of_month).order(log_worked_on: "DESC").group_by(&:attendance_id)
      # Logapply.where(log_worked_on: year_month.beginning_of_month..year_month.end_of_month).order(log_worked_on: "DESC").group_by(&:applicant_user_id)
    else
      # byebug
      Logapply.where(instructor: "承認").order(log_worked_on: "DESC").group_by(&:attendance_id)
      # Logapply.where(instructor: "承認").order(log_worked_on: "DESC").group_by(&:applicant_user_id)
      # byebug
      # @attendance_id.each do |id, attendance|
      #   byebug
      #   # attendance.first
      #   attendance.each do |attendance|     
      #     byebug
      #     # attendance.before_started_at
      #   end
      # end
      
    end
    # byebug
    # respond_to do |format|
    #   format.html  # リクエストされるフォーマットがHTML形式の場合
    #   format.js  # correction_log.js.erbが呼び出される
    # end
  end
end

# Logapply.where(instructor: "承認").group_by(&:attendance_id)
# {67=>[#<Logapply id: 1, log_worked_on: "2021-06-05", before_started_at: "2021-07-18 01:00:00", before_finished_at: "2021-07-18 09:00:00", after_started_at: "2021-07-18 01:00:00", after_finished_at: "2021-07-18 09:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 4, attendance_id: 67, created_at: "2021-07-18 13:41:28", updated_at: "2021-07-18 13:41:28">, #<Logapply id: 5, log_worked_on: "2021-06-05", before_started_at: nil, before_finished_at: nil, after_started_at: "2021-07-18 02:00:00", after_finished_at: "2021-07-18 10:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 4, attendance_id: 67, created_at: "2021-07-18 13:43:22", updated_at: "2021-07-18 13:43:22">], 
# 68=>[#<Logapply id: 2, log_worked_on: "2021-06-06", before_started_at: "2021-07-18 01:00:00", before_finished_at: "2021-07-18 09:00:00", after_started_at: "2021-07-18 01:00:00", after_finished_at: "2021-07-18 09:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 4, attendance_id: 68, created_at: "2021-07-18 13:41:28", updated_at: "2021-07-18 13:41:28">, #<Logapply id: 6, log_worked_on: "2021-06-06", before_started_at: nil, before_finished_at: nil, after_started_at: "2021-07-18 02:00:00", after_finished_at: "2021-07-18 10:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 4, attendance_id: 68, created_at: "2021-07-18 13:43:22", updated_at: "2021-07-18 13:43:22">], 
# 112=>[#<Logapply id: 3, log_worked_on: "2021-06-20", before_started_at: "2021-07-18 01:00:00", before_finished_at: "2021-07-18 09:00:00", after_started_at: "2021-07-18 01:00:00", after_finished_at: "2021-07-18 09:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 2, attendance_id: 112, created_at: "2021-07-18 13:41:28", updated_at: "2021-07-18 13:41:28">, #<Logapply id: 7, log_worked_on: "2021-06-20", before_started_at: nil, before_finished_at: nil, after_started_at: "2021-07-18 02:00:00", after_finished_at: "2021-07-18 10:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 2, attendance_id: 112, created_at: "2021-07-18 13:43:22", updated_at: "2021-07-18 13:43:22">, #<Logapply id: 9, log_worked_on: "2021-06-20", before_started_at: nil, before_finished_at: nil, after_started_at: "2021-07-18 03:00:00", after_finished_at: "2021-07-18 11:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id:2, attendance_id: 112, created_at: "2021-07-18 13:44:43", updated_at: "2021-07-18 13:44:43">, #<Logapply id: 11, log_worked_on: "2021-06-20", before_started_at: nil, before_finished_at: nil, after_started_at: "2021-07-18 04:00:00", after_finished_at: "2021-07-18 12:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 2, attendance_id: 112, created_at: "2021-07-18 13:45:35", updated_at: "2021-07-18 13:45:35">], 
# 113=>[#<Logapply id: 4, log_worked_on: "2021-06-21", before_started_at: "2021-07-18 01:00:00", before_finished_at: "2021-07-18 09:00:00", after_started_at: "2021-07-18 01:00:00", after_finished_at: "2021-07-18 09:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 2, attendance_id: 113, created_at: "2021-07-18 13:41:28", updated_at: "2021-07-18 13:41:28">, #<Logapply id: 8, log_worked_on: "2021-06-21", before_started_at: nil, before_finished_at: nil, after_started_at: "2021-07-18 02:00:00", after_finished_at: "2021-07-18 10:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 2, attendance_id: 113, created_at: "2021-07-18 13:43:23", updated_at: "2021-07-18 13:43:23">, #<Logapply id: 10, log_worked_on: "2021-06-21", before_started_at: nil, before_finished_at: nil, after_started_at: "2021-07-18 03:00:00", after_finished_at: "2021-07-18 11:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 2, attendance_id: 113, created_at: "2021-07-18 13:44:44", updated_at: "2021-07-18 13:44:44">, #<Logapply id: 12, log_worked_on: "2021-06-21", before_started_at: nil, before_finished_at: nil, after_started_at: "2021-07-18 04:00:00", after_finished_at: "2021-07-18 12:00:00", change_day: "2021-07-18", superior: "上長A", instructor: "承認", applicant_user_id: 2, attendance_id: 113, created_at: "2021-07-18 13:45:35", updated_at: "2021-07-18 13:45:35">]}

