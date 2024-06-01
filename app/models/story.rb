class Story < ApplicationRecord
  belongs_to :user
  # 後端驗證，進資料庫前的驗證  
  validates :title, presence: true
  # 注意:title為符號
  # 文章標題欄位必填，沒寫，就會寫入資料庫失敗
end
