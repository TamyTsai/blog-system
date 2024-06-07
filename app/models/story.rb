class Story < ApplicationRecord
  # 軟刪除套件paranoia
  acts_as_paranoid
  # 不用自己寫default scope 也不用覆寫 destroy方法
  # 刪除後進rails c就看不到該筆資料，但進postgre資料庫還看得到
  # 真的想刪除資料的話，使用really_destroy!
  
  extend FriendlyId # 擴充該模組的方法，將方法由實體方法擴充為類別方法，以利作用在Story這個class（model應用系統物件）上
  friendly_id :slug_story, use: :slugged
  # 範例：
  # class User < ApplicationRecord
  #   extend FriendlyId
  #   friendly_id :name, use: :slugged 要用name這個欄位 當作slugged（那串frendly id）的來源
  # end

  include AASM
  # https://github.com/aasm/aasm

  # 驗證validations
  validates :title, presence: true
  # 注意:title為符號
  # 文章標題欄位必填，沒寫，就會寫入資料庫失敗

  # 關聯relationships
  belongs_to :user
  # 後端驗證，進資料庫前的驗證  
  has_one_attached :cover_image
  # 請rails active storage 幫每篇文章弄一個封面照功能
  has_many :comments
  # 動態長出四方法：comments comments= build create
  has_many :bookmarks
  # 一篇文章 可被 多次收藏
  # 如果有需要在後台查詢文章被收藏的數量 的話再開（關聯有需要再建）

  # Scopes
  # default_scope { where(deleted_at: nil) } # 使用paranoia套件就不用這行了
  # 對stories資料表的所有查詢，都要先篩選出deleted_at欄位值nil的資料
  # Scope
  # 把一群條件整理成 一個Scope
  # 減少在Controller裡寫一堆Where組合
  # 用起來跟類別方法一樣
  # default_scope
  # 可幫 所有的查詢 預設套用Scope
  # 副作用是 陰魂不散（擺脫scope：unscopte(:where)）

  # scope :published_stories, -> {where(status: 'published')} 
  # 做一個scope方法 名為published_stories（已發佈的文章）
  # 使用此方法會 套用 篩選status欄位 值為published的 查詢條件（用lambda 建立 物件化 之 程式碼區塊block）
  scope :published_stories, -> { published.with_attached_cover_image.order(created_at: :desc).includes(:user) } 
  # 在controller對 應用程式物件 使用此方法（published_stories）時，會做以下動作：
    # 篩選狀態為已發佈的文章（aasm的方法）
    # 一起解決cover_image欄位讀取上的N+1問題
    # 撈出來的文章 按建立日期由新到舊排序
    # 解決N+1問題


  # 實體方法instance methods

  # 因使用paranoia套件，所以 軟刪除文章的方法 不用自己覆寫destroy方法了
  # def destroy
  #   update(deleted_at: Time.now) 
  # end
  # 原本的destroy方法，會真的把資料刪除，救不回來，由資料庫中抹除
  # 這邊覆寫destroy方法功能變為軟刪除
  # update(deleted_at: Time.now) # 使用destroy方法時，將當下的時間寫到stories資料表中的deleted_at欄位

  # 改善friendly id 中的中文顯示
  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end
  # http://localhost:3000/stories/6-%E6%B8%AC%E8%A9%A6friendly-id/edit
  # 經過babosa轉換後為 http://localhost:3000/stories/6-測試friendly-id/edit

  # aasm
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

  private

  # 產生要被放入friendly id的值
  def slug_story
    [
      :title, # 資料表中的title欄位
      [:title, SecureRandom.hex[0, 8]]
      # SecureRandom.hex會產生32碼的16進位數字
      # [0, 8]會取其中1-8位
      # 會先產生title欄位的值，如果重複，就會加上小橫槓與8碼的16進位數字
      # 但這裡有個問題，就是此值為中文的話，會被轉回原本的編碼->使用babosa

      # http://localhost:3000/stories/五五/edit
      # http://localhost:3000/stories/五五-0fec517d/edit
    ]
  end
  
end

# AASM rails c 測試
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

  # 如果沒有禁止伸手進資料庫改狀態的話
  # 2.7.8 :007 > s1.update(status: 'published')
  # TRANSACTION (0.3ms)  BEGIN
  # User Load (1.9ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  # Story Update (2.3ms)  UPDATE "stories" SET "status" = $1, "updated_at" = $2 WHERE "stories"."id" = $3  [["status", "published"], ["updated_at", "2024-06-02 10:51:27.618471"], ["id", 1]]
  # TRANSACTION (1.2ms)  COMMIT
  # => true 

# friendly id 一次更新所有文章的網址
  # rails c
  # Story.find_each(&:save)
  # 找出stories資料表中 每一筆 資料後 對每一筆資料 做重新寫進資料庫（就會更新網址）的動作
  #   NOTICE:  identifier "spring app    | 部落格系統 | started 0 secs ago | development mode" will be truncated to "spring app    | 部落格系統 | started 0 secs ago | developm"
  #   Story Load (0.6ms)  SELECT "stories".* FROM "stories" WHERE "stories"."deleted_at" IS NULL ORDER BY "stories"."id" ASC LIMIT $1  [["LIMIT", 1000]]
  #   TRANSACTION (0.2ms)  BEGIN
  #   User Load (0.6ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  #   TRANSACTION (0.3ms)  COMMIT
  #   TRANSACTION (0.2ms)  BEGIN
  #   User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  #   TRANSACTION (0.1ms)  COMMIT
  #   TRANSACTION (0.1ms)  BEGIN
  #   User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  #   TRANSACTION (0.1ms)  COMMIT
  #   TRANSACTION (0.1ms)  BEGIN
  #   User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  #   TRANSACTION (0.1ms)  COMMIT
  #   TRANSACTION (0.1ms)  BEGIN
  #   User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  #   TRANSACTION (0.1ms)  COMMIT
  #   TRANSACTION (0.1ms)  BEGIN
  #   User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  #   TRANSACTION (0.1ms)  COMMIT
  #   TRANSACTION (0.0ms)  BEGIN
  #   User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  #   TRANSACTION (0.1ms)  COMMIT
  #   TRANSACTION (0.1ms)  BEGIN
  #   User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  #   TRANSACTION (0.1ms)  COMMIT
  #   TRANSACTION (0.1ms)  BEGIN
  #   User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  #   TRANSACTION (0.1ms)  COMMIT
  #  => nil 

