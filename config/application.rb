require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Blog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.time_zone = 'Asia/Taipei'
    # 時區顯示方式設定為亞洲臺北
    # 改設定檔後 要重新啟動伺服器 才會生效
    # 2024-06-01 20:23:03 +0800

    config.generators do |g| # 參數不一定要取g，但取什麼，程式碼區塊裡的就要寫得一樣
      g.assets false
      g.helper false
      g.test_framework false # 測試框架：本專案沒寫測試，所以可以關掉
    end
    # 如果assets目錄下的東西都要交給webpack打包，就不需要在使用rails generate時，把檔案產生在原assets目錄下（這邊設定不自動產生，要產生就自己建立）
    # 建立cotroller或model時，就不會再把檔案產生在以上目錄
    
    # 可手動將測試資料夾（test）刪除

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
