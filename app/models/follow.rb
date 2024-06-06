class Follow < ApplicationRecord
  belongs_to :user # 一個使用者 可以追蹤多個人
  # 效果等同 belongs_to :user, foreign_key: 'user_id', class_name: 'User'
  # 這是rails的慣例
  belongs_to :following, foreign_key: 'following_id', class_name: 'User'
  # 一個使用者 可以被 多個人 追蹤
  # following是一個實際上並不存在的欄位，只是為了好看懂寫的
  # 寫這種不存在的欄位，就要再後面補充實際資訊
  # 設定該欄位的外鍵為follows表格的following_id欄位（被追蹤的 使用者id）
  # 且去找User model （被追蹤的對象 也是本網站使用者）
  # 本質上對應到 users資料表（User model）
end
