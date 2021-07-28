class AttendancesController < ApplicationController
  
  before_action :set_user, only: [:edit_one_month, :update_one_month, :edit_apprlychange, :update_apprlychange, :edit_over_work_time, :update_over_work_time]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  # 管理権限者またはログインユーザー本人であれば実行可能
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # byebug
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
  end
  
  def update_one_month
    # byebug
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
                
        # if item[:edit_nextday] == "true"
          attendance = Attendance.find(id)
          # byebug
          attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  # 勤怠変更の申請と承認
  def edit_apprlychange
    # byebug
    @attendance = Attendance.new
    @attendance.logapplies.build
    # byebug
    if @user.id == 2
      @attendances = Attendance.where(edit_superior: "上長A").order(worked_on: "DESC").group_by(&:user_id)
    elsif @user.id == 3 
      @attendances = Attendance.where(edit_superior: "上長B").order(worked_on: "DESC").group_by(&:user_id)
    end
  end

  def update_apprlychange
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # @attendance = Attendance.find_by(user_id: params[:user_id])
    # @attendance.logapplies.all
    # byebug
    # ActiveRecord::Base.transaction do # トランザクションを開始します。
      apprlychange_params.each do |id, item3|
        item3.each do |id, item2|
          item2.each do |id, item|
            # byebug
            item[:logapplies_attributes].each do |id, logapplies_attributes| 
              # byebug
              # if logapplies_attributes[:instructor].blank?
                # byebug
                logapplies_attributes[:instructor] = item[:instructor]
 
            end
            # byebug
            if item[:change] == "true" && (item[:instructor] == "申請中" || item[:instructor] == "承認" || item[:instructor] == "否認")
              attendance = Attendance.find(id)
              # byebug
              # if attendance.before_started_at == nil && attendance.before_finished_at == nil
                # attendance = Attendance.find(id)
              attendance.update_attributes!(item)
            end  
          end
        end
      end
    
      flash[:success] = "変更を送信しました。"
      redirect_to user_url(date: params[:date])
    # rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
      # flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      # redirect_to attendances_edit_one_month_user_url(date: params[:date])
    # end
  end

  # 残業申請
  def edit_overtime
    @user = User.find(params[:user_id])
    # @attendance = Attendance.find(params[:id])
    @attendance = Attendance.find_by(id: params[:id], user_id: @user.id, worked_on: params[:date])
  end

  def update_overtime
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # if params[:attendance][:over_nextday] == "true"
    #   over_day = @attendance.worked_on.tomorrow
    # byebug
    if @attendance.update_attributes(overtime_params)
      flash[:success] = "変更を送信しました。"
      redirect_to user_path(@user)
    else 
      flash[:danger] = "変更を送信できませんでした。"
      redirect_to user_path(@user)
    end

  end

  def edit_over_work_time
    # byebug
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @user.id == 2
      @attendances = Attendance.where(over_superior: "上長A").order(worked_on: "DESC").group_by(&:user_id)
    elsif @user.id == 3 
      @attendances = Attendance.where(over_superior: "上長B").order(worked_on: "DESC").group_by(&:user_id)
    end
  end

  def update_over_work_time
    # byebug
    overwork_params.each do |id, overwork|
      overwork.each do |id, over|
        # byebug
        if over[:overtime_change] == "true" && (over[:over_instructor] == "申請中" || over[:over_instructor] == "承認" || over[:over_instructor] == "否認")
        # byebug
          attendance = Attendance.find(id)
          attendance.update_attributes!(over)
        end
      end
      flash[:success] = "変更を送信しました。"
      redirect_to user_path(@user)
    end
    
  end

  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :edit_nextday, :edit_superior])[:attendances]
      # params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :edit_nextday, :edit_superior, logapplies_attributes: [:attendance_id, :applicant_user_id, :log_worked_on, :superior, :before_started_at, :before_finished_at]])[:attendances]
      # params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :edit_nextday, :edit_superior, logapply: [:applicant_user_id, :log_worked_on, :superior, :before_started_at, :before_finished_at]])[:attendances]
     
      # params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :edit_nextday, :edit_superior], logapply: [:applicant_user_id, :log_worked_on, :superior, :before_started_at, :before_finished_at])[:attendances]
    end

    def apprlychange_params
      params.permit(attendance: [attendances: [:change_started_at, :change_finished_at, :instructor, :change, logapplies_attributes: [:id, :attendance_id, :applicant_user_id, :change_day, :instructor, :after_started_at, :after_finished_at, :log_worked_on, :superior, :before_started_at, :before_finished_at]]])
      # params.permit(attendance: [attendances: [:change_started_at, :change_finished_at, :instructor, :change, logapplies_attributes: :change_day, :instructor, :after_started_at, :after_finished_at]])[:attendances]
      # params.permit(attendance: [attendances: :change_started_at, :change_finished_at, :instructor, :change, logapplies_attributes: [:change_day, :instructor, :after_started_at, :after_finished_at]])[:attendances]
    end

    def overtime_params
      if params[:attendance][:over_nextday] == "true"
        over_day = @attendance.worked_on.tomorrow
        over_end_time = params[:attendance]["over_end_time(4i)"] + ":" + params[:attendance]["over_end_time(5i)"]
        params.require(:attendance).permit(:over_nextday, :over_content, :over_superior,).merge(over_end_time: over_end_time,id: params[:id], user_id: params[:user_id], over_day: over_day)
      else
        over_end_time = params[:attendance]["over_end_time(4i)"] + ":" + params[:attendance]["over_end_time(5i)"]
        params.require(:attendance).permit(:over_day, :over_nextday, :over_content, :over_superior,).merge(over_end_time: over_end_time, id: params[:id], user_id: params[:user_id])
      end
        # over_end_time = params[:attendance]["over_end_time(4i)"] + ":" + params[:attendance]["over_end_time(5i)"]
        # params.require(:attendance).permit(:over_day, :over_nextday, :over_content, :over_superior,).merge(over_end_time: over_end_time,id: params[:id], user_id: params[:user_id])

       # params.require(:attendance).permit(:id, :user_id, attendances: [:over_day, :over_end_time, :over_nextday, :over_content, :over_superior]).merge(over_end_time: over_end_time)
      # params.permit(:id, :user_id, attendance: [:over_day, :over_nextday, :over_content, :over_superior]).merge(over_end_time: over_end_time)
      # params.require(:attendance).permit(:id, :user_id, attendance: [:over_day, :over_end_time,"over_end_time(4i)", "over_end_time(5i)", :over_nextday, :over_content, :over_superior])
    end
    
    def overwork_params
      params.require(:attendance).permit(overtime: [:over_work_time, :over_instructor, :overtime_change])
    end

    
    # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end
    
end
