class Api::UtilsController < Api::BaseController

    # 檢查格式（白名單）
    IMAGE_EXT = [".git", ".jpeg", "jpg", ".png", ".svg"] # 陣列中為可通過的 圖片檔案格式
    # IMAGE_EXT 圖片副檔名（extension）

    def upload_image
        # 透過伺服器log檔可知 使用者於文字編輯器上傳圖片後 前端會以POST傳輸一包東西過來 且會存在一個叫file的參數
        f = params[:file] # 抓到 Parameters: {"file"=>.........}

        ext = File.extname(f.original_filename)
        # File 為 Ruby 內建的類別
        # .extname()為類別方法 可作用於File這個類別 作用是傳回參數的副檔名
        # f.original_filename為 剛剛抓到的檔案 的原始檔案名稱
        raise '不允許的檔案類型' unless IMAGE_EXT.include?(ext)
        # 如果 傳上來的檔案的副檔名（ext），不存在於 IMAGE_EXT陣列中 的話，就跳出錯誤訊息「不允許的檔案類型」（噴例外）

        blob = ActiveStorage::Blob.create_after_upload!(
            io: f, # 檔案本身（剛剛抓下來的）
            filename: f.original_filename,
            content_type: f.content_type 
        )
        # https://api.rubyonrails.org/classes/ActiveStorage/Blob.html#method-c-compose
        # rails 6 中 ActiveStorage::Blob類別上 有 create_after_upload! 方法
        # 之前坐上傳檔案功能都是把ActiveStorage掛在某一model底下，這邊則是希望 把檔案吃下來後 直接上傳

        render json: { link: url_for(blob)}
        # 這邊不用status 因為 前端圖片上傳完成 會期望收到一個link
        # 讓前端（文字編輯器）可以抓到 這個圖片路徑 正常顯示於前端
        # url_for(blob) 為 blob的路徑

    end
end