class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_month_application, :basic]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]   
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :on_duty, :basic]
  before_action :set_one_month, only: :show
  before_action :admin_or_correct_user, only: [:on_duty, :basic]
  before_action :superior_or_correct_user, only: :show
  
  
  def index
    # @users = User.all
    @users = User.paginate(page: params[:page],per_page: 10)
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
    if current_user.admin 
      redirect_to(root_url)
    elsif params[:id].to_i == 1
      redirect_to(root_url)
    else


      # csv出力
      respond_to do |format|
        format.html
        format.csv do
          send_data render_to_string, filename: "#{@user.name}さんの勤怠情報.csv", type: :csv
        end
      end
      

      @worked_sum = @attendances.where.not(started_at: nil).count
      # byebug
      @month_superior_A = Approval.all.where(month_superior: '上長A').count
      @month_superior_A_approval = Approval.all.where(month_superior: '上長A', instructor_confirmation: nil).count
      @superior_A_instructor_unapproved = Approval.all.where(month_superior: '上長A', instructor_confirmation: '申請中').count
      @superior_A_instructor_denial = Approval.all.where(month_superior: '上長A', instructor_confirmation: '否認').count
      @month_superior_B = Approval.all.where(month_superior: '上長B').count    
      @month_superior_B_approval = Approval.all.where(month_superior: '上長B', instructor_confirmation: nil).count    
      @superior_B_instructor_unapproved = Approval.all.where(month_superior: '上長B', instructor_confirmation: '申請中').count    
      @superior_B_instructor_denial = Approval.all.where(month_superior: '上長B', instructor_confirmation: '否認').count    
      # byebug

      @edit_superior_A = Attendance.all.where(edit_superior: '上長A').count
      @edit_superior_A_approval = Attendance.all.where(edit_superior: '上長A', instructor: nil).count
      @edit_superior_A_instructor_unapproved = Attendance.all.where(edit_superior: '上長A', instructor: '申請中').count
      @edit_superior_A_instructor_denial = Attendance.all.where(edit_superior: '上長A', instructor: '否認').count
      @edit_superior_B = Attendance.all.where(edit_superior: '上長B').count 
      @edit_superior_B_approval = Attendance.all.where(edit_superior: '上長B', instructor: nil).count
      @edit_superior_B_instructor_unapproved = Attendance.all.where(edit_superior: '上長B', instructor: '申請中').count
      @edit_superior_B_instructor_denial = Attendance.all.where(edit_superior: '上長B', instructor: '否認').count

      # byebug  
      @overtime_superior_A = Attendance.all.where(over_superior: '上長A').count
      @overtime_superior_A_apploval = Attendance.all.where(over_superior: '上長A', over_instructor: nil).count
      @overtime_superior_A_instructor_unapproved = Attendance.all.where(over_superior: '上長A', over_instructor: '申請中').count
      @overtime_superior_A_instructor_denial = Attendance.all.where(over_superior: '上長A', over_instructor: '否認').count
      @overtime_superior_B = Attendance.all.where(over_superior: '上長B').count
      @overtime_superior_B_apploval = Attendance.all.where(over_superior: '上長B', over_instructor: nil).count
      @overtime_superior_B_instructor_unapproved = Attendance.all.where(over_superior: '上長B', over_instructor: '申請中').count
      @overtime_superior_B_instructor_denial = Attendance.all.where(over_superior: '上長B', over_instructor: '否認').count
      
      # byebug
      @app1 = Approval.all.where(month_superior: '上長A').or(Approval.all.where(month_superior: '上長B')).group_by(&:applicant_user_id)
      # @app2 = Approval.all.where(instructor_confirmation: '否認').or(Approval.all.where(instructor_confirmation: '承認')).group_by(&:applicant_user_id)
      @app2 = Approval.find_by(applicant_user_id: params[:id])
      # byebug
    end
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

  def basic
  end
  

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end

    # 管理者
    def admin_or_correct_user
      # byebug
      @user = User.find(params[:id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        # flash[:danger] = "編集権限がありません。"
        flash[:danger] = "不正なアクセスです。"
        redirect_to(root_url)
      end
    end


    # 上長
    def superior_or_correct_user
      # byebug
      @user = User.find(params[:id]) if @user.blank?
      # byebug
      unless current_user?(@user) || current_user.superior?
      # unless current_user?(@user)
      # unless current_user.superior?
        # flash[:danger] = "編集権限がありません。"
        flash[:danger] = "不正なアクセスです。"
        redirect_to(root_url)
      end
    end



end
