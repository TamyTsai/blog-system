class CreateStories < ActiveRecord::Migration[6.1]
  def change
    create_table :stories do |t|
      t.string :title
      t.text :content
      t.string :status, default: 'draft' # 文章狀態 預設為草稿
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

# drop 資料表（migrate檔案有寫錯的話，要先drop掉原本rails db:migrate出來的資料表，修改migrate檔案，再重新rails db:migrate新資料表）
# rails db:rollback （push前 資料庫內還沒有東西前 才能使用）
# == 20240601095405 CreateStories: reverting ====================================
# -- drop_table(:stories)
# -> 0.0026s
# == 20240601095405 CreateStories: reverted (0.0048s) ===========================
