class ApprovalsController < ApplicationController

  # 一か月分の勤怠承認
  def create
    
    @user = User.find(params[:user_id])
    # @atendance = Attendance.find_by(id: params[:user_id])
    # @approval = @attendance.logapplies.find_by(applicant_user_id: @user.id)
    # byebug 
    # @attendance = Logapply.new
    @approval = Approval.new(month_superior_params)
    # @attendance.logapplies.build
    # byebug
    # @approval = @attendance.logapplies(month_superior_params)
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
    @user = User.find_by(id: params[:id])
    # byebug
    @attendance = @user.attendances.find_by(user_id: params[:user_id])
    # byebug
    # @approval = @attendance.logapplies.find_by(applicant_user_id: params[:user_id])
    # byebug
    if @user.id == 2 
      # byebug
      
      @group = Approval.where(month_superior: '上長A').order(one_month: "DESC").group_by(&:applicant_user_id)
      # byebug
    elsif @user.id == 3 
      # @month_superior = @user.approvals.all.where(month_superior: '上長B')
      @group = Approval.where(month_superior: '上長B').order(one_month: "DESC").group_by(&:applicant_user_id)
    end
    # byebug
    
  end

  def update_month_application
    # byebug
    @user = User.find_by(id: params[:user_id])
    @approval = Approval.find_by(applicant_user_id: @user.id)

    # if @user.id == 2 
      # byebug
      # if params[:approval][params[:id]][:checkbox] == "true"
    ActiveRecord::Base.transaction do
  #     # byebug
      update_month_params.each do |id1, approval_param|
        # byebug
        approval_param.each do |id, approval_param|
          # byebug
          if approval_param[:checkbox] == "true" && (approval_param[:instructor_confirmation] == "申請中" || approval_param[:instructor_confirmation] == "承認" || approval_param[:instructor_confirmation] == "否認")
            approval = Approval.find(id)
            approval.update_attributes(approval_param)
          elsif approval_param[:checkbox] == "true" && approval_param[:instructor_confirmation] == "なし"
            approval = Approval.find(id)
            approval.destroy
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
      # params.require(:approval).permit(:one_month, :month_superior)
      params.permit(:one_month, :month_superior, :applicant_user_id, :id)
    end

    def update_month_params
      params.permit(approval: [:instructor_confirmation, :checkbox, :id])
    end

end
