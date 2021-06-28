class AttendancesController < ApplicationController
  
  before_action :set_user, only: [:edit_one_month, :update_one_month, :edit_apprlychange, :update_apprlychange]
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
        if item[:edit_nextday] == "true"
        # byebug
          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
            # byebug
        end
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
    if @user.id == 2
      @attendances = Attendance.where(edit_superior: "上長A").group_by(&:user_id)
    elsif @user.id == 3 
      @attendances = Attendance.where(edit_superior: "上長B").group_by(&:user_id)
    end
  end

  def update_apprlychange
    # byebug
    # ActiveRecord::Base.transaction do # トランザクションを開始します。
      apprlychange_params.each do |id, item|
        if item[:change] == "true"
        # byebug
          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
            # byebug
        end
      end
    
      flash[:success] = "変更を送信しました。"
      redirect_to user_url(date: params[:date])
    # rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
      # flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      # redirect_to attendances_edit_one_month_user_url(date: params[:date])
    # end
  end
  
  
  

  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :edit_nextday, :edit_superior])[:attendances]
    end

    def apprlychange_params
      params.permit(attendances: [:change_started_at, :change_finished_at, :instructor, :change])[:attendances]
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
