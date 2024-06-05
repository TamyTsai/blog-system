# $ rails g model Comment user:references story:references content:text deleted_at:datetime:index

class Comment < ApplicationRecord
  # 軟刪除套件paranoia
  acts_as_paranoid
  # 不用自己寫default scope 也不用覆寫 destroy方法
  # 刪除後進rails c就看不到該筆資料，但進postgre資料庫還看得到
  # 真的想刪除資料的話，使用really_destroy!acts_as_paranoid

  belongs_to :user
  # 動態長出兩方法：user、user=
  belongs_to :story

  # 驗證validations
  validates :content, presence: true
  # 注意:content 為符號
  # 留言內容欄位必填，沒寫，就會寫入資料庫失敗
end


