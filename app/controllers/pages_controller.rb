class PagesController < ApplicationController

    before_action :find_story, only: [:show]

    def index # 全站首頁 的action
        # @stories = Story.all # 將stories資料表中的所有資料撈出來，指定給實體變數@stories
        # @stories = Story.order(created_at: :desc).includes(:user)
        # 將stories資料表中的所有資料撈出來由建立日期新到舊排序（不限當前使用者的文章，而是stories資料表中所有文章）
        # vs stroy controller：@stories = current_user.stories.all.order(created_at: :desc) （當前使用者的文章）
        # 用.includes(:user)解決N+1問題（撈資料時的SQL語法會改用IN的寫法來寫）

        # 篩選出狀態為已發佈之文章
        # @stories = Story.where(status: 'published').order(created_at: :desc).includes(:user)
        # 此為新手寫法，老手寫法為去model加scope，提升程式碼再用性，且如果要改變搜尋條件，只要去model改，所有用此scope方法篩選的地方就會一次被修改
        # @stories = Story.published_stories.order(created_at: :desc).includes(:user)
        # rails c
            #    (1.8ms)  SELECT COUNT(*) FROM "stories" WHERE "stories"."deleted_at" IS NULL
            #  => 12 
            #  2.7.8 :002 > Story.published_stories.count
            #     (2.3ms)  SELECT COUNT(*) FROM "stories" WHERE "stories"."deleted_at" IS NULL AND "stories"."status" = $1  [["status", "published"]]
            #   => 4 
            #  2.7.8 :003 > Story.published.count （.published為aasm送的方法）
            #     (1.0ms)  SELECT COUNT(*) FROM "stories" WHERE "stories"."deleted_at" IS NULL AND "stories"."status" = $1  [["status", "published"]]
            #   => 4 
        # 更進階寫法為直接用aasm送的方法
        # @stories = Story.published.order(created_at: :desc).includes(:user)

        # 想同時解決封面照片讀取的N+1問題的話
        # @stories = Story.published.with_attached_cover_image.order(created_at: :desc).includes(:user)
        # .with_attached_欄位名稱 為 rails的方法
        # 遇到冗長且還有機會再用到的方法，可以把程式碼搬到model中，以利程式碼的再用
        @stories = Story.published_stories

        # N+1問題：
        # 原始伺服器log顯示之查詢語法
            # Started GET "/" for ::1 at 2024-06-03 19:56:00 +0800
            # (0.5ms)  SELECT "schema_migrations"."version" FROM "schema_migrations" ORDER BY "schema_migrations"."version" ASC
            # Processing by PagesController#index as HTML
            # Rendering layout layouts/application.html.erb
            # Rendering pages/index.html.erb within layouts/application
            # Story Load (2.7ms)  SELECT "stories".* FROM "stories" WHERE "stories"."deleted_at" IS NULL ORDER BY "stories"."created_at" DESC
            # ↳ app/views/pages/index.html.erb:81
            # User Load (1.7ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/views/pages/index.html.erb:84
            # CACHE User Load (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/views/pages/index.html.erb:84
            # CACHE User Load (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/views/pages/index.html.erb:84
            # CACHE User Load (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/views/pages/index.html.erb:84
            # CACHE User Load (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/views/pages/index.html.erb:84
            # CACHE User Load (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/views/pages/index.html.erb:84
            # CACHE User Load (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/views/pages/index.html.erb:84
            # CACHE User Load (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/views/pages/index.html.erb:84
            # CACHE User Load (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/views/pages/index.html.erb:84
            # Rendered pages/index.html.erb within layouts/application (Duration: 30.3ms | Allocations: 21626)
            # [Webpacker] Everything's up-to-date. Nothing to do
            # User Load (0.8ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 ORDER BY "users"."id" ASC LIMIT $2  [["id", 2], ["LIMIT", 1]]
            # ↳ app/views/shared/frontend/_navbar.html.erb:30
            # ActiveStorage::Attachment Load (1.9ms)  SELECT "active_storage_attachments".* FROM "active_storage_attachments" WHERE "active_storage_attachments"."record_id" = $1 AND "active_storage_attachments"."record_type" = $2 AND "active_storage_attachments"."name" = $3 LIMIT $4  [["record_id", 2], ["record_type", "User"], ["name", "avatar"], ["LIMIT", 1]]
            # ↳ app/helpers/users_helper.rb:4:in `avatar'
            # ActiveStorage::Blob Load (0.8ms)  SELECT "active_storage_blobs".* FROM "active_storage_blobs" WHERE "active_storage_blobs"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/helpers/users_helper.rb:4:in `avatar'
            # Rendered shared/frontend/_navbar.html.erb (Duration: 31.0ms | Allocations: 19065)
            # Rendered layout layouts/application.html.erb (Duration: 84.7ms | Allocations: 65443)
            # Completed 200 OK in 107ms (Views: 61.5ms | ActiveRecord: 28.1ms | Allocations: 71810)

        # 加上includes後的 伺服器log顯示之查詢語法
            # Started GET "/" for ::1 at 2024-06-03 19:58:54 +0800
            # Processing by PagesController#index as HTML
            # Rendering layout layouts/application.html.erb
            # Rendering pages/index.html.erb within layouts/application
            # Story Load (0.7ms)  SELECT "stories".* FROM "stories" WHERE "stories"."deleted_at" IS NULL ORDER BY "stories"."created_at" DESC
            # ↳ app/views/pages/index.html.erb:81
            # User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1  [["id", 1]]
            # ↳ app/views/pages/index.html.erb:81
            # Rendered pages/index.html.erb within layouts/application (Duration: 17.3ms | Allocations: 12879)
            # [Webpacker] Everything's up-to-date. Nothing to do
            # User Load (0.7ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 ORDER BY "users"."id" ASC LIMIT $2  [["id", 2], ["LIMIT", 1]]
            # ↳ app/views/shared/frontend/_navbar.html.erb:30
            # ActiveStorage::Attachment Load (0.6ms)  SELECT "active_storage_attachments".* FROM "active_storage_attachments" WHERE "active_storage_attachments"."record_id" = $1 AND "active_storage_attachments"."record_type" = $2 AND "active_storage_attachments"."name" = $3 LIMIT $4  [["record_id", 2], ["record_type", "User"], ["name", "avatar"], ["LIMIT", 1]]
            # ↳ app/helpers/users_helper.rb:4:in `avatar'
            # ActiveStorage::Blob Load (0.5ms)  SELECT "active_storage_blobs".* FROM "active_storage_blobs" WHERE "active_storage_blobs"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
            # ↳ app/helpers/users_helper.rb:4:in `avatar'
            # Rendered shared/frontend/_navbar.html.erb (Duration: 28.9ms | Allocations: 16213)
            # Rendered layout layouts/application.html.erb (Duration: 53.9ms | Allocations: 38985)
            # Completed 200 OK in 59ms (Views: 37.2ms | ActiveRecord: 18.9ms | Allocations: 41670)
    end

    def show # 檢視單篇文章頁面 的 action
        # 抓出特定文章
        # before action已做
    end

    def user # 檢視單一作者所有文章頁面 的 action
    end

    private

    def find_story
        @story = Story.friendly.find(params[:story_id])
        # 抓出id為:story_id的文章
        # babosa要求要寫成 @story = current_user.stories.friendly.find(params[:story_id])才不會抓不到id（因為網址中原id已經被friendly id轉換）
    end

end
