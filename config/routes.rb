Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :stories # 做一個 文章們（符號） 相關的資源 出來 ＃複數 :複數 #複數resources長8條路徑對照7個方法 ＃單數resource的話會長7條路徑對照7個方法 不長有關id的路徑

  root 'pages#index'
  # 將首頁設定至 pages controller中的 index action
end
