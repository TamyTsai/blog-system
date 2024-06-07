class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 驗證validations
  validates :username, presence: true, uniqueness: true
  # 後端驗證
  # 使用者名稱欄位必填 且唯一不重複

  # 關聯性relationships
  has_many :stories
  # 一個使用者會對應多篇文章
  # has_many不是設定，是 類別方法（作用在class Candidate）
  # has_many :stories會動態產生幾個實體方法：stories  stories=  build  create
  # build 放在記憶體中，尚未儲存，.save後才寫進資料庫
  # create 直接寫進資料庫
  # has_many :comments
  # comment model在rails g時會自動產生與User、Story的關聯（因為有references這兩個欄位）
  # 但User與Story要has_one或has_many comments 就要自己手動設定
  has_many :follows
  # 一個使用者 可有 多個追蹤者
  has_many :bookmarks
  # 一個使用者 可收藏 多篇文章
  has_one_attached :avatar
  # 請rails active storage 幫每個使用者弄一個大頭貼功能

  # 實體方法instance method (用本類別建出的model物件 都可以用的方法)
  def follow?(user) # 使用者 是否有追蹤 使用者user？（慣例上 方法最後為問號者 會回傳布林值）
    # follows.where(following: user)
    # 去follows資料表，篩選following（被追蹤者）欄位值為user的 資料
    # 但此方法會回傳陣列 浪費資源
    follows.exists?(following: user)
    # exists?方法會檢查()中條件是否存在，並回傳布林值，比較省資源
  end

  def follow!(user) # 使用者按下 追蹤按鈕後 要執行的動作（讓使用者 追蹤或取消追蹤 使用者user） （慣例上 方法最後為驚嘆號者 會有一些行為）
    if follow?(user) # 已經追蹤user了
      follows.find_by(following: user).destroy
      # 去follows表格，找出following（被追蹤者）欄位為user（被追蹤者）的資料，然後刪除該資料
      return '追蹤'
      # 後續會拿來傳到user_controller.js中，以拿來操縱畫面html元素（追蹤鈕上面的字），所以退追後，按鈕要顯示為「追蹤」，供使用者重新追蹤
    else # 尚未追蹤user
      follows.create(following: user)
      # 去follows表格 的 following（被追蹤者）欄位，新增值：user
      # create會直接把資料寫進資料庫（不像new還要再save）
      return '追蹤中'
    end
  end

  # 中控台（follow）
    # 2.7.8 :002 > Hirb.enable
    # => true 
    
    # 2.7.8 :007 > User.first.follow?(User.first) （1號使用者 有沒有 追蹤 1號使用者？）
    #   User Load (1.0ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   User Load (0.3ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   Follow Exists? (1.6ms)  SELECT 1 AS one FROM "follows" WHERE "follows"."user_id" = $1 AND "follows"."following_id" = $2 LIMIT $3  [["user_id", 1], ["following_id", 1], ["LIMIT", 1]]
    # => false （沒有）

    # 2.7.8 :008 > User.first.follow?(User.last)（1號使用者 有沒有 追蹤 最後一號使用者？）
    #   User Load (0.9ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT $1  [["LIMIT", 1]]
    #   Follow Exists? (0.6ms)  SELECT 1 AS one FROM "follows" WHERE "follows"."user_id" = $1 AND "follows"."following_id" = $2 LIMIT $3  [["user_id", 1], ["following_id", 2], ["LIMIT", 1]]
    # => false （沒有）

    # 2.7.8 :009 > User.first.follow!(User.last) （讓1號使用者 追蹤 最後一號使用者（如果原本未追蹤的話））
    #   User Load (0.8ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   User Load (0.4ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT $1  [["LIMIT", 1]]
    #   Follow Exists? (0.6ms)  SELECT 1 AS one FROM "follows" WHERE "follows"."user_id" = $1 AND "follows"."following_id" = $2 LIMIT $3  [["user_id", 1], ["following_id", 2], ["LIMIT", 1]]
    #   TRANSACTION (0.2ms)  BEGIN
    #   Follow Create (2.4ms)  INSERT INTO "follows" ("user_id", "following_id", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["user_id", 1], ["following_id", 2], ["created_at", "2024-06-06 07:12:13.776254"], ["updated_at", "2024-06-06 07:12:13.776254"]]
    #   TRANSACTION (0.6ms)  COMMIT
    # => "Followed" （追蹤中）

    # 2.7.8 :010 > User.first.follow?(User.last)（1號使用者 有沒有 追蹤 最後一號使用者？）
    #   User Load (0.8ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   User Load (0.5ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT $1  [["LIMIT", 1]]
    #   Follow Exists? (0.7ms)  SELECT 1 AS one FROM "follows" WHERE "follows"."user_id" = $1 AND "follows"."following_id" = $2 LIMIT $3  [["user_id", 1], ["following_id", 2], ["LIMIT", 1]]
    # => true （有）

  
  def bookmark?(story)
    bookmarks.exists?(story: story) # 回傳 使用者 是否有 收藏此文章（參數傳進來的文章）
  end

  def bookmark!(story)
    if bookmark?(story) # 使用者 已經收藏 該篇文章（story）了
      bookmarks.find_by(story: story).destroy
      # 去bookmarks表格，找出story（被收藏的文章）欄位為 參數傳進來的文章 的資料，然後刪除該資料
      return '未收藏'
    else # 使用者 尚未收藏 該篇文章（story）
      bookmarks.create(story: story)
      # 去bookmarks表格 的 story（被收藏文章）欄位，新增值：story（傳進來的文章）
      # create會直接把資料寫進資料庫（不像new還要再save）
      return '已收藏'
    end
  end
  # 中控台（bookmark）
    # 2.7.8 :001 >  User.first.bookmark?(Story.first) （第一個使用者 有收藏 第一篇文章嗎？）
    #   User Load (0.7ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   Story Load (0.7ms)  SELECT "stories".* FROM "stories" WHERE "stories"."deleted_at" IS NULL ORDER BY "stories"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   Bookmark Exists? (1.2ms)  SELECT 1 AS one FROM "bookmarks" WHERE "bookmarks"."user_id" = $1 AND "bookmarks"."story_id" = $2 LIMIT $3  [["user_id", 1], ["story_id", 1], ["LIMIT", 1]]
    # => false （沒有）
    # 2.7.8 :002 > User.first.bookmark!(Story.first) （第一個使用者 收藏 第一篇文章（如果原本未收藏的話））
    #   User Load (1.4ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   Story Load (0.4ms)  SELECT "stories".* FROM "stories" WHERE "stories"."deleted_at" IS NULL ORDER BY "stories"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   Bookmark Exists? (0.7ms)  SELECT 1 AS one FROM "bookmarks" WHERE "bookmarks"."user_id" = $1 AND "bookmarks"."story_id" = $2 LIMIT $3  [["user_id", 1], ["story_id", 1], ["LIMIT", 1]]
    #   TRANSACTION (0.2ms)  BEGIN
    #   Bookmark Create (9.2ms)  INSERT INTO "bookmarks" ("user_id", "story_id", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["user_id", 1], ["story_id", 1], ["created_at", "2024-06-07 01:30:21.955107"], ["updated_at", "2024-06-07 01:30:21.955107"]]
    #   TRANSACTION (0.6ms)  COMMIT
    # => "已收藏" 
    # 2.7.8 :003 > User.first.bookmark?(Story.first)（第一個使用者 有收藏 第一篇文章嗎？）
    #   User Load (1.0ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   Story Load (0.4ms)  SELECT "stories".* FROM "stories" WHERE "stories"."deleted_at" IS NULL ORDER BY "stories"."id" ASC LIMIT $1  [["LIMIT", 1]]
    #   Bookmark Exists? (0.9ms)  SELECT 1 AS one FROM "bookmarks" WHERE "bookmarks"."user_id" = $1 AND "bookmarks"."story_id" = $2 LIMIT $3  [["user_id", 1], ["story_id", 1], ["LIMIT", 1]]
    # => true （有）



end
