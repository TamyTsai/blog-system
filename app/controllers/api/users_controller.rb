# $ rails g controller users

class Api::UsersController < Api::BaseController
# routes加上namespace api 後，這裡也要幫 類別 加上 Api::(模組)
# 本UsersController 為 Api模組 下的 類別，並且繼承自 Api::BaseController類別

    before_action :find_user

    def follow
        render json: {status: current_user.follow!(@user)}
        # follow!為寫在user model的實體方法，用 User類別 建立出的 實體物件 都可以使用
        # current_user.follow!(@user) 會回傳 unFollow或Followed

        # story = Story.friendly.find(params[:id])# 先把要被拍手的故事抓出來
        # # params[:id]抓出打過來網址的id
        # story.increment!(:clap)
        # # 對story物件（根據網址id被抓出來的 要被拍手的文章） 之 clap欄位 值 進行+1 的 動作
        # # t.integer "clap", default: 
        # # !表示不需要再兩階段地再使用.save方法（Rails慣例中 方法名稱帶驚嘆號的 表示會直接更動資料）
        # render json: {status: story.clap}
        # # 回傳 story物件（根據網址id被抓出來的 要被拍手的文章） 之 clap欄位 值（用json格式回傳給 打資料給此API 的檔案）
    end

    private

    def find_user # 找出 要被追蹤的 使用者
        @user = User.find(params[:id])
    end

end
