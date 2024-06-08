class UsersController < ApplicationController

    def pricing # 會員升級頁面 對應 的 action
    end

    def payment # 升級付費頁面 對應 的 action
        @fee = ENV["price_#{params[:type]}"]
        # 用params[:type]抓網址裡type對應的值
        # 透過環境變數 動態指定值 給 @fee
        @payment_type = (params[:type] == 'vip')? 'VIP會員' : '白金會員'
        # 用三元運算指定值 給 @payment_type
        @token = gateway.client_token.generate
    end

    private

    def gateway
        Braintree::Gateway.new(  # Braintree中長出token的方法
            environment: :sandbox,
            merchant_id: ENV['braintree_merchant_id'],
            public_key: ENV['braintree_public_key'],
            private_key: ENV['braintree_private_key'],
        )
        # 網站上是舊式寫法hash {:merchant_id => ,}
    end

end
