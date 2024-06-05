class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :stories
  # 一個使用者會對應多篇文章
  # has_many不是設定，是 類別方法（作用在class Candidate）
  # has_many :stories會動態產生幾個實體方法：stories  stories=  build  create
  # build 放在記憶體中，尚未儲存，.save後才寫進資料庫
  # create 直接寫進資料庫
  has_many :comments
  # comment model在rails g時會自動產生與User、Story的關聯（因為有references這兩個欄位）
  # 但User與Story要has_one或has_many comments 就要自己手動設定

  validates :username, presence: true, uniqueness: true
  # 後端驗證
  # 使用者名稱欄位必填 且唯一不重複

  has_one_attached :avatar
  # 請rails active storage 幫每個使用者弄一個大頭貼功能

end
