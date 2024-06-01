class StoriesController < ApplicationController
    # 權限控管，做本controller的任何動作前，檢查是否為登入狀態，把沒有登入的人踢到登入頁面
    before_action :authenticate_user!
    before_action :find_story, only: [:edit, :update, :destroy]

    def index # 文章列表頁面 的 action
        # 沒有特別聲明的話，就會去views找同名html檔案（stories資料夾下的index.html.erb）
        @stories = current_user.stories.all.order(created_at: :desc)
        # 透過.all類別方法，將 當前 使用者的所有文章撈出來，指定給實體變數@stories（因為撈了多筆資料，所用複數型）
        # .order(created_at: :desc)讓撈出來的文章 按建立時間欄位值排序（新到舊）
        # ORM基本操作之R
        # Story.all 列出所有候選人（物件、model、資料表中的一筆資料）資料
        # Story.select('title') 同上，只選取title欄位
        # Story.where(title: 'Ruby') 找出所有title欄位是Ruby的資料
        # Story.order('age DESC') 依照年齡大小反向排序
        # Story.order(age: :desc) 同上
        # Story.limit(5) 只取出5筆資料

        # @stories = current_user.stories.where(deleted_at: nil).order(created_at: :desc)
        # Story.where(deleted_at: nil) 找出所有deleted欄位是nil的資料
        # 只撈出沒有刪除時間的資料（刪除時間欄位有資料的文章 表示已經被使用者按下刪除）
        # 但這樣做很麻煩，所以軟刪除的另一個慣用手法是default_scope（寫在story model中）
    end

    def new # 新增文章頁面 的 action
        # @story = Story.new # 建立 一筆資料（model、物件） # new方法會 建立 一筆資料，但還不會存到資料庫裡  # ORM基本操作之C：new、create
        # 沒有帶東西，全新物件
        # model：class Story < ApplicationRecord
        # 指定給一個變數，view才能拿到
        # 建立物件的寫法寫在controller會比寫在view好，view拿這裡給的實體變數呈現畫面就好

        @story = current_user.stories.new
        # 於user model 設定has_many :stories，動態產生幾個實體方法：stories  stories=  build  create
        # build 放在記憶體中，尚未儲存，.save後才寫進資料庫
        # create 直接寫進資料庫
    end

    def create # 將新增文章頁面的資料 傳到後端 的 action
        @story = current_user.stories.new(story_params)
        # 以Story建立物件model時，將清洗過後的資料傳進該物件
        # 資料還沒清洗過 的話，會被預設檔下來，出現ActiveModel::ForbiddenAttributesError 錯誤訊息
        # 表示需要 資料清洗
        # 雖然有token的保護，有心人士無法透過其他程式或網站傳送資料進來這裡的後端，但他們還是可以在我們的頁面上用開發者模式，編輯html，新增欄位，成功送更多資料到這裡的後端

        if @story.save # 若成功將文章輸入框中的資料 寫入資料庫

            redirect_to stories_path, notice: "文章新增成功!"
            # redirect_to stories_path # 跳回文章列表頁
            # "文章新增成功!"為要提示的訊息（需要透過view呈現在畫面（轉址頁面））
            # 在離開頁面時，給一個flash，flash的key為notice
            # 失敗的話可以用alert這個key
            # notice與alert為特化版的key # 舊版rails沒有這種寫法
            # flash的view適合放在layouts（公版）

        else # 若 寫入失敗（格式不對、驗證沒過...）（在model做後端驗證（進資料庫前的驗證））          
            # redirect_to new_story_path
            # 就不跳回文章列表頁，而是停留在本頁面（新建文章頁面），但此寫法會轉回全新頁面，導致所有資料都要重填
            # http沒有所謂的狀態，這頁寫好的東西，轉址後的網頁不會知道
            render :new 
            # 去new這個頁面，重新渲染一次（不是重新執行new方法（action）），是請view中的new頁面重畫一次
            # 本質上還是在create這個action中，並非執行new action
            # render就是要借new.html檔案來用
            # new.html檔案需要＠story 實體變數（所以才會在create action中，也寫一個跟new action中相同的 ＠story實體變數）（但也有 沒 這麼剛好（有同名實體變數）的狀況）
            # 這裡抓到的 ＠story實體變數 已經不像new action中是新創出來的，是裡頭已經有料（story_params）的 物件、model
        end
    end

    def edit # 編輯已建立之文章 的 action
    end

    def update # 對應以PATCH動詞（事實上是POST PATCH是模擬的）進入的/stories/:id路徑（story_path）（將進入 編輯已建立的文章頁面 後，所更新的文章資料 儲存）

        if @story.update(story_params) # 成功更新資料時
            # ORM基本操作之U
            # update()
            # update_attributes()
            # update_all()
            # 給一包清洗過的資料
            # flash[:notice] = "文章已更新!"
            # redirect_to '/stories' # 回到使用者故事列表頁
                redirect_to stories_path, notice: "文章已更新!"
            else
                render :edit
                # 去edit這個頁面，重新渲染一次（不是重新執行edit方法（action）），是請view中的edit頁面重畫一次
            end
    end

    def destroy # 對應以DELETE動詞（事實上是GET DELETE是模擬的）進入的/stories/:id路徑（story_path）（刪除已建立的文章）

        @story.destroy
        # ORM基本操作之D
        # delete （直接刪掉）
        # destroy （會經歷一連串callback）（真的把資料刪除，救不回來，由資料庫中抹除） 
        # destroy_all(condition = nil)
        # flash[:notice] = "Candidate deleted!"
        # redirect_to '/candidates' # 回到候選人列表頁

        # @story.update(deleted_at: Time.now) # 將當下的時間寫到stories資料表中的deleted_at欄位
        # 但這樣寫不太直覺，所以這種軟刪除的慣用手法 是 去覆寫destroy方法（去Story model覆寫）

        redirect_to stories_path, notice: "文章已刪除!"

        # 抓資料
        # 刪資料
        # 跳提示
        # 重新導向頁面
    end

    private # 作用範圍是 以下 直到 本class的end為止，所以要寫在最後
    def story_params
        params.require(:story).permit(:title, :content) #省略return之寫法
        # return可適時省略，會自動 回傳 最後一行 的 執行結果
    end
    # 資料還沒清洗過 的話，資料送出轉址時會被預設檔下來，出現ActiveModel::ForbiddenAttributesError 錯誤訊息
    # 表示需要 資料清洗
    # 雖然有token的保護，有心人士無法透過其他程式或網站傳送資料進來這裡的後端，但他們還是可以在我們的頁面上用開發者模式，編輯html，新增欄位，成功送更多資料到這裡的後端
    # 此方法本身不需要被外部存取，只在這個class中會被用到（用來代替落落長的 資料清洗過的欄位資料），所以設為private方法
    # private：原則上只有 類別內部 可以操作，但實際上 只要沒有明確訊息接收者 都可以呼叫

    def find_story
        # 只要抓 當前 使用者的文章，並非資料庫所有文章（所有 使用者的所有文章）
        @story = current_user.stories.find(params[:id])
        # params[:id]文章編號
        # 撈當前使用者編號為id之文章資料 給 實體變數story
        # @story = Story.find_by(id: params[:id])
    end

end

# 看資料庫裡的東西
# rails c
# 2.7.8 :001 > Story.all
# NOTICE:  identifier "spring app    | 部落格系統 | started 0 secs ago | development mode" will be truncated to "spring app    | 部落格系統 | started 0 secs ago | developm"
# Story Load (0.4ms)  SELECT "stories".* FROM "stories" /* loading for inspect */ LIMIT $1  [["LIMIT", 11]]
# => #<ActiveRecord::Relation [#<Story id: 1, title: "第一篇文章", content: "大家好", status: "draft", user_id: 1, created_at: "2024-06-01 12:00:13.828994000 +0000", updated_at: "2024-06-01 12:00:13.828994000 +0000">]> 
# 2.7.8 :002 > 