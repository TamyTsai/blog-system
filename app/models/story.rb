class Story < ApplicationRecord
  include AASM
  # https://github.com/aasm/aasm

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

  aasm column: 'status', no_direct_assignment: true do
    # column: 'status' 原預設會去資料表找名叫aasm的欄位，這裡改成去找名為status的欄位
    # no_direct_assignment: true 不允許手直接伸進資料庫更改該欄位之值
    state :draft, initial: true # 預設狀態（草稿）
    state :published # 已發佈

    event :publish do
      transitions from: :draft, to: :published
      
      # 會在publish之後執行此程式碼區塊
      # after do
      #   puts "發佈簡訊"
      # end
    end

    event :unpublish do
      transitions from: :published, to: :draft
    end
  end
end

# rails c
# 2.7.8 :001 > s1 = Story.first
# NOTICE:  identifier "spring app    | 部落格系統 | started 0 secs ago | development mode" will be truncated to "spring app    | 部落格系統 | started 0 secs ago | developm"
# Story Load (1.6ms)  SELECT "stories".* FROM "stories" WHERE "stories"."deleted_at" IS NULL ORDER BY "stories"."id" ASC LIMIT $1  [["LIMIT", 1]]
# => #<Story id: 1, title: "第一篇文章", content: "大家好", status: "draft", user_id: 1, created_at: "2024-06-01 20:00:13.828994000 +0800", updated_at: "2024-06-01 20:00:13.828994000 +0800", deleted_at: nil> 
# 2.7.8 :002 > s1
# => #<Story id: 1, title: "第一篇文章", content: "大家好", status: "draft", user_id: 1, created_at: "2024-06-01 20:00:13.828994000 +0800", updated_at: "2024-06-01 20:00:13.828994000 +0800", deleted_at: nil> 
# 2.7.8 :003 > s1.draft?
# => true 
# 2.7.8 :004 > s1.published?
# => false 
# 2.7.8 :005 > s1.may_publish?
# => true 
# 2.7.8 :006 > s1.may_unpublish?
# => false 
# 不允許手直接伸進資料庫更改該欄位之值
# 2.7.8 :005 > s1.update(status: 'published')
# Traceback (most recent call last):
#         1: from (irb):5
# AASM::NoDirectAssignmentError (direct assignment of AASM column has been disabled (see AASM configuration for this class))
# 2.7.8 :006 > s1.publish!
# TRANSACTION (0.4ms)  BEGIN
# User Load (0.8ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
# Story Update (3.2ms)  UPDATE "stories" SET "status" = $1, "updated_at" = $2 WHERE "stories"."id" = $3  [["status", "published"], ["updated_at", "2024-06-02 11:03:18.700434"], ["id", 1]]
# TRANSACTION (0.9ms)  COMMIT
# => true 
# 2.7.8 :007 > s1.unpublish!
# TRANSACTION (0.6ms)  BEGIN
# Story Update (1.0ms)  UPDATE "stories" SET "status" = $1, "updated_at" = $2 WHERE "stories"."id" = $3  [["status", "draft"], ["updated_at", "2024-06-02 11:19:30.020309"], ["id", 1]]
# TRANSACTION (1.1ms)  COMMIT
# => true 
# 2.7.8 :008 > s1.draft?
# => true 
# 2.7.8 :009 > s1.published?
# => false 
# 2.7.8 :013 > s1.may_publish?
# => true 
# 2.7.8 :011 > s1.may_unpublish?
# => false 

# after
# 2.7.8 :003 > s1.status
#  => "published" 
# 2.7.8 :004 > s1.unpublish!
# TRANSACTION (0.4ms)  BEGIN
# User Load (1.5ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
# Story Update (1.4ms)  UPDATE "stories" SET "status" = $1, "updated_at" = $2 WHERE "stories"."id" = $3  [["status", "draft"], ["updated_at", "2024-06-02 11:37:26.960543"], ["id", 1]]
# TRANSACTION (1.0ms)  COMMIT
#  => true 
# 2.7.8 :005 > s1.publish!
#  TRANSACTION (1.8ms)  BEGIN
#  Story Update (1.3ms)  UPDATE "stories" SET "status" = $1, "updated_at" = $2 WHERE "stories"."id" = $3  [["status", "published"], ["updated_at", "2024-06-02 11:38:12.869286"], ["id", 1]]
# 發佈簡訊
#  TRANSACTION (1.1ms)  COMMIT
# => true 

# 2.7.8 :007 > s1.update(status: 'published')
# TRANSACTION (0.3ms)  BEGIN
# User Load (1.9ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
# Story Update (2.3ms)  UPDATE "stories" SET "status" = $1, "updated_at" = $2 WHERE "stories"."id" = $3  [["status", "published"], ["updated_at", "2024-06-02 10:51:27.618471"], ["id", 1]]
# TRANSACTION (1.2ms)  COMMIT
# => true 
