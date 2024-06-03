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

  validates :username, presence: true, uniqueness: true
  # 後端驗證
  # 使用者名稱欄位必填 且唯一不重複

end
