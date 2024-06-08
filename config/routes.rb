Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # devise_for :users，devise套件幫忙長出來的，會自己去找該對應的controller在哪
  devise_for :users, controllers: {
    registrations: 'users/registrations' # 但客制化devise，跟routes說 註冊相關功能的部分 要特別使用哪個controller
  }

  # 若在routes裡想要有 階層 的寫法 可以用namespace
  # namespace :api 都放api相關路徑
  namespace :api do
    # namespace :v2 do # 想改版的話可以這樣寫，然後再去相關地方改路徑，就能升級api
    # follow_api_v2_user   POST   /api/v2/users/:id/follow(.:format)          api/v2/users#follow
    # clap_api_v2_story   POST   /api/v2/stories/:id/clap(.:format)        api/v2/stories#clap
      resources :users, only:[] do
        member do 
          post :follow
        end
      end
      # follow_user    POST   /users/:id/follow(.:format)     users#follow
      # 因users的CRUD devise已經幫我們做好，故 only:[] 接空陣列 表示 與users有關的8條路徑7個方法都不要做
      # 我們只需要/users/:id/follow路徑
      # 要被follow功能api打的路徑
      # 加上namespace api後
      # follow_api_user   POST   /api/users/:id/follow(.:format)    api/users#follow

      
      resources :stories, only:[] do
        member do
          post :clap
          # html動詞 :action
          post :bookmark
        end
        # 幫原本的8條路徑再擴充其他路徑（帶id）
        # clap_story    POST   /stories/:id/clap(.:format)      stories#clap
        # post比較不容易被仿造（會檢查token） get只要知道路徑 就可以灌票
        # 要被拍手功能api打的路徑
        # 加上namespace api後
        # clap_api_story   POST   /api/stories/:id/clap(.:format)     api/stories#clap
        # bookmark_api_story   POST   /api/stories/:id/bookmark(.:format)       api/stories#bookmark
      end

      post :upload_image, to: 'utils#upload_image'
      # 在name space api底下 擴充 upload_image路徑（不帶id），並指定 此路徑 對應 utils controller 的 upload_image action
      # api_upload_image   POST   /api/upload_image(.:format)      api/utils#upload_image
    # end
  
  end
  
  resources :users, only: [] do
    # 不做8條路徑 7個action
    collection do
      get :pricing # 點擊導覽列之 會員升級後 用get方法 到pricing action（在users controller裡）
      get :payment # 在會員升級頁面 點擊購買 所導向的頁面 （用get方法 到payment action（在users controller裡））
    end
    # 幫原本的路徑擴充其他路徑（不帶id）
    # pricing_users    GET    /users/pricing(.:format)       users#pricing
    # payment_users    GET    /users/payment(.:format)       users#payment
  end

  # resources :stories # 做一個 文章們（符號） 相關的資源 出來 ＃複數 :複數 #複數resources長8條路徑對照7個方法 ＃單數resource的話會長7條路徑對照7個方法 不長有關id的路徑
  resources :stories do
    resources :comments, only: [:create] # 每篇文章下會有很多留言，直接把留言路徑資源做在文章下
    # 只會用到create action的相關路徑（只需要新增留言）
    # rails routes | grep comments
    # 只長出  story_comments    POST   /stories/:story_id/comments(.:format)     comments#create
  end

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
