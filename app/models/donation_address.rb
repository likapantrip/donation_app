class DonationAddress
  # ActiveModel::Modelをinclude
  include ActiveModel::Model
  # donationsテーブルとaddressesテーブルに保存したいカラム名
  attr_accessor :postal_code, :prefecture, :city, :house_number, :building_name, :price, :user_id

  # donationsテーブルとaddressesテーブルのバリデーション
  with_options presence: true do
    validates :price, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000000, message: 'is invalid'}
    validates :user_id # belongs_to :userのアソシエーションによって設定されているバリデーションを新たに追加
    validates :postal_code, format: {with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)"}
  end
  validates :prefecture, numericality: {other_than: 0, message: "can't be blank"}

  # フォームから送られてきた情報をテーブルに保存する処理
  def save
    # 寄付情報を保存し、変数donationに代入する
    donation = Donation.create(price: price, user_id: user_id)
    # 住所を保存する
    # donation_idには、変数donationのidと指定する
    Address.create(postal_code: postal_code, prefecture: prefecture, city: city, house_number: house_number, building_name: building_name, donation_id: donation.id)
  end
end