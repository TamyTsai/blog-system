# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths += Dir["#{Rails.root}/vendor/assets/*"] 
# 把vendor底下的assets資料夾下的東西也加到assets這個搜尋路徑中，方便拿來用
# #{Rails.root}表示整個rails專案的根目錄
# *表示資料夾內所有東西
# 改設定檔，要重啟rails server才會生效

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
