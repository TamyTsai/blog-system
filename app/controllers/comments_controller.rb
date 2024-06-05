class CommentsController < ApplicationController
    # 權限控管，做本controller的任何動作前，檢查是否為登入狀態，把沒有登入的人踢到登入頁面
    before_action :authenticate_user!

    before_action :find_story, only: [:create]

    def create # 將新增留言頁面的資料 傳到後端 的action
        @comment = @story.comments.new(comment_params)
        # 每一篇故事會有很多留言（要先去story model設定 has_many :comments 才會有comments方法可用）
        # has_many :comments 動態長出四方法：comments comments= build create
        # 傳入清洗過的資料
        # 建立comments物件 並綁在對應的story底下
        @comment.user= current_user
        # class Comment < ApplicationRecord
        # belongs_to :user
        # 動態長出兩方法：user、user=
        # 把此留言 綁在 當前登入的使用者底下
        # 將 current_user物件 丟給 @comment（綁在對應story下的comments物件）

        if @story.save # 若成功將 留言輸入框中 的資料 寫入資料庫
            render js: "alert('ok')"
            # 回傳一段js
            # rails的UJS機制來說，rails會執行 回傳的 js
            # view 的 form_with 有寫到 remote: ture（預設），資料傳送出去，傳回來是一包js的話，就執行該js
            # <Comment id: 1, user_id: 1（第1個使用者）, story_id: 12（在第12篇文章下）, content: "這是留言", deleted_at: nil, created_at: "2024-06-05 11:19:25.647908000 +0800", updated_at: "2024-06-05 11:19:25.647908000 +0800"> 
            # 1號留言 為 1號使用者 在 12號文章 寫下 「這是留言」的留言
        else # 若 寫入失敗（格式不對、驗證沒過...）（在model做後端驗證（進資料庫前的驗證））          
            render js: "alert('error')"
        end
    end


    private

    def comment_params # 資料清洗 ＃強參數
        params.require(:comment).permit(:content)
        # 只允許 內容欄位 通過 本強參數
        #省略return之寫法
        # return可適時省略，會自動 回傳 最後一行 的 執行結果
    end

    def find_story # 抓出要被留言的文章
        @story = Story.friendly.find(params[:story_id])
    end

end
