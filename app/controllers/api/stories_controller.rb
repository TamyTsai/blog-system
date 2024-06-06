class Api::StoriesController < Api::BaseController

    def clap # 按下拍手按鈕 的 action（按下拍手按鈕後 API 傳資料給 frontend/controllers/story_controller.js）
        # clap_story POST   /stories/:id/clap(.:format)      stories#clap
        story = Story.friendly.find(params[:id])# 先把要被拍手的故事抓出來
        # params[:id]抓出打過來網址的id
        story.increment!(:clap)
        # 對story物件（根據網址id被抓出來的 要被拍手的文章） 之 clap欄位 值 進行+1 的 動作
        # t.integer "clap", default: 
        # !表示不需要再兩階段地再使用.save方法（Rails慣例中 方法名稱帶驚嘆號的 表示會直接更動資料）
        render json: {status: story.clap}
        # 回傳 story物件（根據網址id被抓出來的 要被拍手的文章） 之 clap欄位 值（用json格式回傳給 打資料給此API 的檔案）
    end

end