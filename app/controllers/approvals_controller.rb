class ApprovalsController < ApplicationController
  before_action :set_user, only: [:month_superior_application, :edit_month_application, :update_month_application ]
  # before_action :set_one_month, only: :edit_month_application

  def create
    # byebug
    @user = User.find_by(id: params[:user_id])
    @approval = @user.approvals.find_by(user_id: @user.id)
    # @approval = @attendance.approvals.find_by(attendance_id: params[:attendance_id]) 
    # @approval = @attendance.approvals.find_by()
    # byebug 
    @approval = @user.approvals.new(month_superior_params)
    # byebug
    if @approval.save
      # log_in @user
      flash[:success] = "承認申請を#{@approval.month_superior}に送りました。"
        redirect_to user_path(@user)
      # flash[:success] = '新規作成に成功しました。'
      # redirect_to @user
    else
      flash[:danger] = "所属長承認を選択してください。"
      redirect_to user_path(@user) 
    end
    
    # else
    #   render :new
    # end
  end


  # 所属長承認申請のお知らせ
  def edit_month_application
    @user = User.find_by(id: params[:user_id])
    @approval = @user.approvals.find_by(user_id: @user.id)
    
    # byebug
    if @user.id == 2 
      # @month_superior = @user.approvals.all.where(month_superior: '上長A')
      # @month_superior = Approval.all.where(month_superior: '上長A').group_by(&:user_id)
      # byebug
      
      @group = Approval.where(month_superior: '上長A').group_by(&:user_id)
      # byebug
      # @group2 = Approval.where(month_superior: '上長A').map{|item| item.one_month}

      # @users = User.joins(:approvals).where(approvals: {month_superior: '上長A'}).group(:user_id).map{|item| item.name} 
      
    elsif @user.id == 3 
      # @month_superior = @user.approvals.all.where(month_superior: '上長B')
      @group = Approval.where(month_superior: '上長B').group_by(&:user_id)
    end
    # byebug
    
  end

  def update_month_application
    # byebug
    @user = User.find_by(id: params[:user_id])
    @approval = Approval.find_by(user_id: @user.id)

    # if @user.id == 2 
      # byebug
      # if params[:approval][params[:id]][:checkbox] == "true"
    ActiveRecord::Base.transaction do
  #     # byebug
      update_month_params.each do |id, approval_param|
        approval_param.each do |id, approval_param|
          # if params[:approval][params[:id]][:checkbox] == "true"
          if approval_param[:checkbox] == "true"
            approval = Approval.find(id)
            approval.update_attributes(approval_param)
            # flash[:success] = "変更を送信しました。"
            # redirect_to user_path(@user)  
          # elsif approval_param[:checkbox] == "false"
          #   flash[:danger] = "変更にチェックしてください。"
          #   redirect_to user_path(@user) 
          end 
        end
      end
      flash[:success] = "変更を送信しました。"
      redirect_to user_path(@user)      
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "変更を送信できませんでした。"
      redirect_to user_path(@user)
    end
      # else
      #   flash[:danger] = "変更にチェックしてください。"
      #   redirect_to user_path(@user) 
      # end  

    # elsif @user.id == 3 
      # if params[:approval][params[:id]][:checkbox] == "true"
    #     ActiveRecord::Base.transaction do
    #       update_month_application_params.each do |id, approval_param|
    #         approval_param.each do |id, approval_param|
    #           if approval_param[:checkbox] == "true"
    #           # byebug
    #             approval = Approval.find(id)
    #             approval.update_attributes(approval_param)
    #           end
    #         end
    #       end
    #       flash[:success] = "変更を送信しました。"
    #       redirect_to user_path(@user)
    #     rescue ActiveRecord::RecordInvalid
    #       flash[:danger] = "変更を送信できませんでした。"
    #       redirect_to user_path(@user)
    #     end
    #   # else
    #   #   flash[:danger] = "変更にチェックしてください。"
    #   #   redirect_to user_path(@user) 
    #   # end
    # end
  end

  private

    def month_superior_params
      # params.require(:user).permit(attendances: :month_superior)[:attendances]
      params.require(:approval).permit(:one_month, :month_superior)
      # params.permit(:one_month, :month_superior)
    end

    def update_month_params
      params.permit(approval: [:user_id, :instructor_confirmation, :checkbox])
    end

    # def update_month_application_params
    #   # params.require(:approval)
    #   params.require(:approval).permit(approval: [:user_id, :instructor_confirmation, :checkbox])
      
    # end

end
