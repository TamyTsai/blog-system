class Api::BaseController < ApplicationController
    skip_before_action :verify_authenticity_token
    # 表單使用POST方法傳送時，預設會檢查token，沒有token會被檔下來
    # 點擊追蹤按鈕，表單打過來時，不檢查token（因為是透過一般API過來）
    # 安全性？至少有檢查有無登入
    # api相關controller都不想要被檢查token，所以放在這個共用類別
    
    before_action :check_login

    private

    def check_login
        unless user_signed_in? # 如果使用者沒登入
            render json: {status: 'sign_in_first'} # 收到這個狀態 我們再根據狀態（透過在controller.js寫流程控制）在畫面上alert出來
            return
        end
    end

end

# 其他的資料夾 祖先類別為ApplicationController，既然新建了api資料夾，就在api資料夾裡也建一個自己的 祖先類別 Api::BaseController（在Api模組下（在routes中namespace設定為api））
# 然後讓這個 祖先類別BaseController 也繼承自其他資料夾的 始祖類別ApplicationController，這樣 本資料夾下的其他controller就可以繼承本類別BaseController即可
# BaseController專門放api資料夾下所有controller共用的東西
# 這裡可以在ApplicationController的基礎下，再塞入api獨有共用的東西