# $ rails g migration add_colums_to_users username:uniq intro:text
# 新增username及intro欄位 到users資料表，username欄位資料類型為string（省略不寫），並設定為不重複，intro欄位資料類型為uniq

class AddColumsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true # 使用者帳號不重複
    add_column :users, :intro, :text
  end
end
