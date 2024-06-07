class Api::StoriesController < Api::BaseController

    before_action :find_story

    def clap # 按下拍手按鈕 的 action（按下拍手按鈕後 API 傳資料給 frontend/controllers/story_controller.js）
        # clap_story POST   /stories/:id/clap(.:format)      stories#clap

        # params[:id]抓出打過來網址的id
        @story.increment!(:clap)
        # 對story物件（根據網址id被抓出來的 要被拍手的文章） 之 clap欄位 值 進行+1 的 動作
        # t.integer "clap", default: 
        # !表示不需要再兩階段地再使用.save方法（Rails慣例中 方法名稱帶驚嘆號的 表示會直接更動資料）
        render json: {status: @story.clap}
        # 回傳 story物件（根據網址id被抓出來的 要被拍手的文章） 之 clap欄位 值（用json格式回傳給 打資料給此API 的檔案）
    end

    def bookmark # 按下 文章蒐藏按鈕 的 action（按下 文章蒐藏按鈕後 controller.js會往這個後端路徑打，就會使用bookmark action）
        # bookmark_api_story   POST   /api/stories/:id/bookmark(.:format)       api/stories#bookmark
        render json: {status: current_user.bookmark!(@story)} # 現在登入的當前使用者 收藏或取消收藏 此篇故事（.bookmark!(@story)會回傳「未收藏」或「已收藏」）
    end

    private

    def find_story
        @story = Story.friendly.find(params[:id]) # 把目前網址所對應的故事抓出來
    end

end