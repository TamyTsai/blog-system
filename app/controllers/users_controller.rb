# $ rails g controller users

class UsersController < ApplicationController

    before_action :find_user

    skip_before_action :verify_authenticity_token, only: [:follow]
    # 表單使用POST方法傳送時，預設會檢查token，沒有token會被檔下來
    # 點擊追蹤按鈕，表單打過來時，不檢查token（因為是透過一般API過來）
    # 安全性？至少有檢查有無登入

    def follow
        if user_signed_in? # 有登入的話
            
            render json: {status: 'ok'}

            # story = Story.friendly.find(params[:id])# 先把要被拍手的故事抓出來
            # # params[:id]抓出打過來網址的id
            # story.increment!(:clap)
            # # 對story物件（根據網址id被抓出來的 要被拍手的文章） 之 clap欄位 值 進行+1 的 動作
            # # t.integer "clap", default: 
            # # !表示不需要再兩階段地再使用.save方法（Rails慣例中 方法名稱帶驚嘆號的 表示會直接更動資料）
            # render json: {status: story.clap}
            # # 回傳 story物件（根據網址id被抓出來的 要被拍手的文章） 之 clap欄位 值（用json格式回傳給 打資料給此API 的檔案）
        else # 沒登入的話
            render json: {status: 'sign_in_first'} # 收到這個狀態 我們再根據狀態（透過在story_controller.js寫流程控制）在畫面上alert出來
        end
    end

    private

    def find_user
        @user = User.find(params[:id])
    end

end
