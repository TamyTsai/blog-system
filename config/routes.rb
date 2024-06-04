Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # devise_for :users，devise套件幫忙長出來的，會自己去找該對應的controller在哪
  devise_for :users, controllers: {
    registrations: 'users/registrations' # 但客制化devise，跟routes說 註冊相關功能的部分 要特別使用哪個controller
  }

  resources :stories # 做一個 文章們（符號） 相關的資源 出來 ＃複數 :複數 #複數resources長8條路徑對照7個方法 ＃單數resource的話會長7條路徑對照7個方法 不長有關id的路徑

  # 某一使用者 的 某一篇文章 頁面路徑
  # /@使用者名稱/文章標題-123
  get '@:username/:story_id', to: 'pages#show', as: 'story_page'
  # 當網址於@:username/:story_id，且使用get方法，就使用 pages controller的show action
  # prefix前綴 為story_page
  #  story_page  GET   /@:username/:story_id(.:format)      pages#show

  # 單一使用者的所有文章 頁面路徑
  get '@:username', to: 'pages#user', as: 'user_page'
  #  user_page  GET    /@:username(.:format)      pages#user

  # stimulus範例
  get '/demo',to: 'pages#demo'

  root 'pages#index'
  # 將首頁設定至 pages controller中的 index action
end
