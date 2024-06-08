class UsersController < ApplicationController

    def pricing # 會員升級頁面 對應 的 action
    end

    def payment # 升級付費頁面 對應 的 action
        @fee = ENV["price_#{params[:type]}"]
        # 用params[:type]抓網址裡type對應的值
        # 透過環境變數 動態指定值 給 @fee
        @payment_type = (params[:type] == 'vip')? 'VIP會員' : '白金會員'
        # 用三元運算指定值 給 @payment_type
        @token = gateway.client_token.generate # .client_token.generate 為 Braintree中長出token的方法
    end

    def pay # 以POST方法 送出 付款頁面的信用卡資料 所對應的 action
        # render html: params # 先把 使用者 於 付款頁面 輸入的信用卡資料 抓出來看看  # render跟redirect_to在同一個action中只能挑一個
        # 客戶端已取得token，尚未取得nonce：{"authenticity_token"=>"dzsTtj6B5AppmzZmYVJigI9ytb9PwXvOofmyW_WsQbL_VDUcrml2VMYTTFA6nHh1WPS_Q70C3qpEmV_GLin3zw", "controller"=>"users", "action"=>"pay"}
        # 客戶端取得token及nonce：{"authenticity_token"=>"uZ7dIcJDpQD3hyZt1GHGKkF4ruaJE2FEzVo9QZg5tEQx8fuLUqs3XlgPXFuPr9zflv6kGnvQxCAoOtDcQ7wCOQ", "payment_nonce"=>"tokencc_bj_kzvr5p_f84h42_npk5py_5c4vgx_9c5", "controller"=>"users", "action"=>"pay"}
        # 注意 這邊看不到 信用卡卡號等信用卡資訊，因為 使用者敏感資訊不應該被我們記錄，我們只要拿著 客戶給我們的nonce向Braintree請求進行交易即可

        fee = ENV["price_#{params[:type]}"] # 在付款頁面送出資料時 要先抓到頁面網址上會員類型的參數 才會知道要讓（使用者購買哪種類型會員）使用者刷多少錢
        nonce = params[:payment_nonce] # 抓到傳輸過來的nonce

        # Create a transaction
        result = gateway.transaction.sale( # result 為交易結果
            # hash中 列出 要銷售的東西資訊
            amount: fee, # 要收的金額（信用卡付款金額）
            payment_method_nonce: nonce,
            # device_data: device_data_from_the_client,
            options: {
                submit_for_settlement: true
            }
        )

        # Transaction Result Object 有一些看交易結果的方法
        if result.success? # .success?方法是 用來識別交易是否成功的方法 # 如果 交易成功
            # 改變 使用者 會員角色
            current_user.send("#{params[:type]}_user!") # 對當前登入的使用者send #{params[:type]}_user!方法（根據 網址type參數（key）對應的value，把當前登入的使用者 之會員角色 變成 對應的會員角色）
            # 在send裡面傳的參數（方法名稱） 就可以使用 雙引號加 變數串接字串的寫法，沒用send()就沒辦法這樣寫
            # meta programming：動態 組合出 要執行的方法，只有 動態程式語言 可做到，在程式運轉過程中 還能 再動態決定要執行什麼方法

            # if params[:type] == 'vip' # 如果網址type參數（key）對應vip（value）（表示 使用者 是要買 vip會員資格）
            #     current_user.vip_user! # 就 把當前登入的使用者 之會員角色 變成 vip會員
            # else # 如果網址type參數（key）非對應vip（value）（表示 使用者 是要買 白金會員資格）
            #     current_user.platium_user! # 就 把當前登入的使用者 之會員角色 變成 白金會員
            # end

            redirect_to root_path, notice: '付款成功'
            # 頁面就跳轉至 首頁，並提示 付款成功
        else
            redirect_to root_path, notice: '付款發生錯誤'
        end

    end

    private

    def gateway
        Braintree::Gateway.new(  # 設定相關資訊
            environment: :sandbox,
            merchant_id: ENV['braintree_merchant_id'],
            public_key: ENV['braintree_public_key'],
            private_key: ENV['braintree_private_key'],
        )
        # 網站上是舊式寫法hash {:merchant_id => ,}
    end

end
