# $ rails g model Bookmark user:references story:references
# 紀錄 哪個使用者 收藏 哪篇文章

class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :story, null: false, foreign_key: true

      t.timestamps
    end
  end
end
