class Story < ApplicationRecord
  belongs_to :user
  # 後端驗證，進資料庫前的驗證  
  validates :title, presence: true
  # 注意:title為符號
  # 文章標題欄位必填，沒寫，就會寫入資料庫失敗

  default_scope { where(deleted_at: nil) }
  # 對stories資料表的所有查詢，都要先篩選出deleted_at欄位值nil的資料
  # Scope
  # 把一群條件整理成 一個Scope
  # 減少在Controller裡寫一堆Where組合
  # 用起來跟類別方法一樣
  # default_scope
  # 可幫 所有的查詢 預設套用Scope
  # 副作用是 陰魂不散（擺脫scope：unscopte(:where)）

  def destroy
    update(deleted_at: Time.now) 
  end
  # 原本的destroy方法，會真的把資料刪除，救不回來，由資料庫中抹除
  # 這邊覆寫destroy方法功能變為軟刪除
  # update(deleted_at: Time.now) # 使用destroy方法時，將當下的時間寫到stories資料表中的deleted_at欄位
end
