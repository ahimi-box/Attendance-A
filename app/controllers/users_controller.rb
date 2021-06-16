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
    
    # @approval = @user.approvals.find_by(user_id: @user.id)
    @approval = @user.approvals.find_by(id: params[:id])
    @approval = @user.approvals.new
    @approvals = @user.approvals.all
    # @attendance = @user.attendances.find_by(user_id: @user.id) 
    # byebug
    # @approval_A = @user.approvals.all.where(checkbox: true, month_superior: "上長A")
    # @approval_B = @user.approvals.all.where(checkbox: true, month_superior: "上長B")
    # @approval_C = @user.approvals.all.where(checkbox: true, instructor_confirmation: "承認")
    # @approval_D = @user.approvals.all.where(checkbox: true, instructor_confirmation: "否認")
    # @approvals = @user.approvals.all
# byebug

    
    
    # byebug
    # @approval = @attendance.approvals.all
    # @approval = @attendance.approvals.find_by(month_superior: "上長A") || @attendance.approvals.find_by(month_superior: "上長B")
    # @approval = @approval.next_day1
    #  byebug

    #  @approval_date = @user.attendances.where(worked_on: @first_day) 
    #  byebug
    # if @approval.month_superior.nil? && @approval.instructor_confirmation.nil?
    #   @app = "所属長承認：未"
    # else
    #   @app = "所属長承認：#{@approval.month_superior}から#{@approval.instructor_confirmation}済"
    # end
    # @approval2 = @attendance.approvals.find_by(instructor_confirmation: "申請中")

    # byebug
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
