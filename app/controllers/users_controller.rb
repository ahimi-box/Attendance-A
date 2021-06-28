class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_month_application]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]   
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  before_action :admin_or_correct_user, only: :show
  
  def index
    @users = User.all

    # # 条件分岐
    # @users = if params[:search].present?
       #searchされた場合は、原文+.where('name LIKE ?', "%#{params[:search]}%")を実行
    #   User.paginate(page: params[:page]).search(params[:search])
    # else
    #   #searchされていない場合は、原文そのまま
    #   User.paginate(page: params[:page])
    # end
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @month_superior_A = Approval.all.where(month_superior: '上長A').count
    @month_superior_B = Approval.all.where(month_superior: '上長B').count    
    # byebug

    @edit_superior_A = Attendance.all.where(edit_superior: '上長A').count
    @edit_superior_B = Attendance.all.where(edit_superior: '上長B').count    
    
    @approval = @user.approvals.find_by(id: params[:id])
    @approval = @user.approvals.new
    @approvals = @user.approvals.all
    
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def import
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    redirect_to users_url
  end

  def on_duty
    @users = User.all
  end

  
  

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end

    
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      # unless current_user?(@user) || current_user.admin?
      unless current_user?(@user) || current_user.superior?
        # flash[:danger] = "編集権限がありません。"
        flash[:danger] = "不正なアクセスです。"
        redirect_to(root_url)
      end
    end


end
