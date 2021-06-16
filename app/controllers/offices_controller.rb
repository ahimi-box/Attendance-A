class OfficesController < ApplicationController
  def index
    @offices = Office.all
    # @user = User.find(params[:user_id])
    @office = Office.new   
  end

  def create 
    @user = User.find(params[:user_id])
    @office = @user.offices.new(office_params)
    if @office.save
      log_in @user
      flash[:success] = '拠点情報登録に成功しました。'
      redirect_to user_offices_url
    else
      flash[:danger] = '拠点情報登録に失敗しました。'
      redirect_to user_offices_url
    end
  end

  def edit
    @office = Office.find(params[:id])
  end

  def update
    @office = Office.find(params[:id])
    if @office.update_attributes(office_params)
      flash[:success] = "拠点情報を修正しました。"
      redirect_to user_offices_url
    else
      flash[:danger] = '拠点情報の修正に失敗しました。'
      redirect_to user_offices_url
    end
  end

  def destroy
    @office = Office.find(params[:id])
    @office.destroy
    flash[:success] = "#{@office.number}のデータを削除しました。"
    redirect_to user_offices_url
  end

  private
  
    def office_params
      # params.permit(:user_id, :number, :name, :category)
      params.require(:office).permit(:user_id, :number, :name, :category)
    end

end
