module UsersHelper # 檔名與模組名稱有嚴格對應關係，打錯字就引入不了了

    def avatar(user, size = 250)
        # image_tag user.avatar.variant(resize: "#{size}x#{size}"), class: 'user-avatar' if user.avatar.attached?
        image_tag user.avatar.variant(resize_to_fill: [size,size]), class: 'user-avatar' if user.avatar.attached?
    end

    # 原本寫在erb檔案的程式碼：
    # <%= image_tag current_user.avatar.variant(resize: '250x250'), class: 'user-avatar' if current_user.avatar.attached? %>
    # size = 250 表示size參數之預設值為250，如果size參數沒有傳入引數，就會是250（有引數用引數，沒引數用預設）
    # 此方法 可在 傳入的使用者avatar欄位有值時，讓畫面顯示 傳入的使用者 其avatar欄位中的圖片 並改變圖片大小
    # "#{size}*#{size}" 將size變數轉字串（因為resize後面要接字串）
    # class: 'user-avatar'用以方便以css選取控制該縮圖

    # resize_to_fill: [size,size] 可以把圖片裁切成此長寬（這裡設長寬一樣，所以是正方形）

end
