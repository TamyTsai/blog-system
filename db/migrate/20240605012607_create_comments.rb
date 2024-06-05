# $ rails g model Comment user:references story:references content:text deleted_at:datetime:index
#  user:references原形為user_id:interger
# 留言需要知道是哪個user_id寫的；留在哪篇story_id下；要有文字內容；要用偏執狂套件軟刪除，所以需要deleted_at欄位

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :story, null: false, foreign_key: true
      t.text :content
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :comments, :deleted_at
  end
end

# $ rails db:migrate後，會根據此描述檔 在資料庫建立資料表
