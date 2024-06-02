# rails g migration add_deleted_at_to_story deleted_at:datetime:index
# 新增一個add_deleted_at_to_story migration
# 新增deleted_at到stories資料表，deleted_at資料類型為datetime
# migration名為AddDeletedAtToStory 檔名為add_deleted_at_to_story

class AddDeletedAtToStory < ActiveRecord::Migration[6.1]
  def change # 會根據語法去猜 為 正向或反向，增加欄位的話，migration roll back時，就會知道要砍掉一個欄位
    add_column :stories, :deleted_at, :datetime # 在現有的stories資料表中，新增一個deleted_at欄位，該欄位資料類型為datetime 
    # 為表格增加欄位
    add_index :stories, :deleted_at # 因為deleted_at這個欄位會很常被搜尋到，所有的搜尋都會問文章是否有此欄位（文章如果有資料刪除時間，代表已經被使用者刪除），所以加上index增進查找效能
  end

  # 早期寫法
  # def up # 正向
  #   create
  # end
  # def down # 反向
  #   delete
  # end
end


# 用delete_at欄位的好處是，可以知道使用者 點擊 刪除文章 的時間，datetime與Boolean（只用布林值標記文章是否被刪除（刪除就不可見））比起來 缺點是 會浪費額外空間

# 非 $ rails g model 模型名稱（首字母大寫） 欄位名稱:資料型態

# rails db:migrate後 就會 在資料庫中現有的stories資料表中，新增一個deleted_at欄位，該欄位資料類型為datetime ，並加上index欄位
