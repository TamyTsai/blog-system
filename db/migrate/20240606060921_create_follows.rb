# $ rails g model Follow user:references following_id:integer:index
# user:references  按下追蹤的使用者
# following_id:integer:index  被追蹤的使用者
# following_id:integer:index  因為沒有另外的表格 也沒有要做多對多關聯 所以沒用references寫法

class CreateFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t| # 建立名為follows的 資料表
      t.references :user, foreign_key: true
      t.integer :following_id

      t.timestamps
    end
    add_index :follows, :following_id
  end
end
