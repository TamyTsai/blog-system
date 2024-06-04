source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.8'

# production群組

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1' # $ rails _6.1.4.6_ new myproject -d postgresql，沒這樣建專案的話，也可來此處手動改要使用的資料庫
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# webpack：前端圈主流的打包工具
# 可幫你將js或是css這些檔案 全部打包好，壓縮成一個檔案
# webpacker是webpack的gem
# Webpacker 是一種 Ruby Gem。當 rails new 專案時，Rails 會自動安裝 Webpacker，Webpacker 則會「幫忙安裝一切 Webpack 工具所需的檔案。」
# Webpack 是一種 自動化 編譯 及 打包 的工具。它幫我們把檔案 編譯 成 瀏覽器 看得懂的內容，並打包好上傳到 server，再提供給 瀏覽器去解析
gem 'webpacker', '~> 5.0'
# $ rails webpacker:install 會幫你把相關的骨架建立起來
# 會把套件安裝在node modules的目錄中


# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# 使用官方上傳檔案系統 處理縮圖
gem 'image_processing', '~> 1.2'
# $ brew install ImageMagick
# ImageMagick為用ruby寫的gem，會呼叫ImageMagic來做縮圖
# 沒安裝此套件的話，會縮圖失敗

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
# 會員系統套件，只要用 devise 就可以在幾分鐘甚至是幾十秒內就把會員註冊、登入、登出、忘記密碼等會員基本的功能完成
gem 'devise', '~> 4.9', '>= 4.9.4'
# 有限狀態機，表示有限個狀態以及在這些狀態之間的轉移和動作等行為的數學計算模型，可以防止資料庫被亂動（手不用直接伸進資料庫）
gem 'aasm', '~> 5.5'
# friendly_id，讓網址可以不洩漏過多資訊
gem 'friendly_id', '~> 5.5', '>= 5.5.1'
# babosa可以改善friendly_id中的中文顯示
gem 'babosa', '~> 2.0'
# paranoia軟刪除
# 正常功能 並非開發或測試才會用到的功能
gem 'paranoia', '~> 2.6', '>= 2.6.3'

# 開發群組
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # foreman 可方便在本機端一次執行多個指令（啟動伺服器 等）（跟production不太相關，所以放在開發群組）
  # 會去你的專案找Procfile檔案
  # 新建Profile，並在裡面寫下希望foreman領班幫你做的事
  # 例如：
  # web: bin/rails server -p 3000：表示會去port3000幫你開啟rails伺服器（自己用rails開伺服器，會預設開在port3000，所以不用特別打）（前面web:可隨便取 不一定要叫此名，foreman開始跑後可以用名稱辨別做了什麼事）
  # webpacker: bin/webpack-dev-server：幫你開啟webpack伺服器
  # $ foreman start 後 就會開始跑Procfile中寫的指令
  gem 'foreman', '~> 0.88.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
