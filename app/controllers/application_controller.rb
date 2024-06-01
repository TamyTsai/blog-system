class ApplicationController < ActionController::Base
    # 其他controller都繼承自ApplicationController
    # 所以在這裡寫的動作會影響所有controller
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    # 遇到噴ActiveRecord::RecordNotFound錯誤訊息的例外時，使用record_not_found方法
    
    
    private
    # 找不到頁面時使用的方法（以404頁面渲染）
    def record_not_found
        render file: "#{Rails.root}/public/404.html",
               status: :not_found,
               layout: false
        # 用某檔案作渲染
        # 檔案路徑為 本專案的根目錄 中 的 public資料夾 中的404.html檔案
        # "#{}"為字串安插
        # 狀態為not_found
        # 不要套用layout（公版）
    end

end
