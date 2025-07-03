class DonationsController < ApplicationController
  before_action :authenticate_user!, except: :index
  def index
  end

  def new
    # newアクションで生成したインスタンスは、form_withのmodelオプションに指定できる
    @donation_address = DonationAddress.new
  end

  def create
    # エラーハンドリングしていた場合、ストロングパラメーターによって値を取得したインスタンスが、renderで表示されたビューのmodelオプションに指定
    @donation_address = DonationAddress.new(donation_address_params)

    if @donation_address.valid?
      @donation_address.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  # ストロングパラメーターを設定
  def donation_address_params
    # フォームがFormオブジェクトのインスタンスに紐付くことにより、送信されるパラメーターは、donation_addressハッシュを含む二重構造になる
    params.require(:donation_address).permit(:postal_code, :prefecture, :city, :house_number, :building_name, :price).merge(user_id: current_user.id)
  end

  # ストロングパラメーターを削除
  # def donation_params
  #   params.permit(:price).merge(user_id: current_user.id)
  # end

  # def address_params
  #   params.permit(:postal_code, :prefecture, :city, :house_number, :building_name).merge(donation_id: @donation.id)
  # end
end