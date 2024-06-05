# $ rails g migration add_counter_to_story
# 增加 counter相關欄位 到stroies資料表（沒有用rails g 直接長欄位，而是長檔案而已，自己來手動編輯增加欄位）

class AddCounterToStory < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :clap, :integer, default: 0
    # 在 stories資料表 增加 資料型態為整數 的 clap欄位，該欄位預設值為0
  end
end

# rails db:migrate
# == 20240605071130 AddCounterToStory: migrating ================================
# -- add_column(:stories, :clap, :integer, {:default=>0})
# -> 0.0024s
# == 20240605071130 AddCounterToStory: migrated (0.0025s) =======================