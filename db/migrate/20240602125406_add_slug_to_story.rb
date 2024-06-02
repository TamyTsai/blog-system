
# https://github.com/norman/friendly_id
# 範例：rails g migration AddSlugToUsers slug:uniq
# $ rails g migration add_slug_to_story slug:uniq
# 增加slug欄位到stroies資料表中，slug的資料型態為string（省略不寫），資料不可重複（uniq）

class AddSlugToStory < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :slug, :string # 在現有的stories資料表中，新增一個slug欄位，該欄位資料類型為string
    # 為表格增加欄位
    add_index :stories, :slug, unique: true
  end
end

