## 簡介
- 本專案為一個部落格系統
- 以HTML、CSS、JavaScript及Ruby撰寫，為動態網頁
- 設計模式（design pattern）採用MVC架構
- 樣式部分以SCSS撰寫，提升程式碼可讀性
- 使用Bulma樣式及效果設計頁面，並達成RWD效果，使網頁適應各尺寸裝置瀏覽
- 圖示使用Font Awesome，以方便控制大小顏色等設定
- 使用ES6使JavaScript語法變得簡潔（箭頭函式等）
- 採用UJS寫法，維持HTML簡潔
- 運用AJAX技術於留言、文章拍手、追蹤使用者及收藏文章功能
- 使用Stimulus框架
- 使用axios串接API
- 使用Turbolinks讓網頁切換更快速
- 使用Froala editor製作文章編輯器
- 使用Rails框架製作網頁
- 使用Active Storage處理圖檔上傳功能，並使用image processing處理上傳後之圖檔
- 使用devise套件製作會員系統功能，並客製化
- 使用aasm有限狀態機操控文章狀態
- 使用friendly id套件，美化網址顯示，並達避免洩漏過多資訊之效果；另使用babosa套件，讓文章標題可以中文顯示在網址中
- 使用paranoia套件，讓文章之刪除功能為軟刪除
- 使用figaro套件，設定全域環境變數，並避免內含機敏資訊之檔案被git追蹤
- 使用braintree進行金流串接（Paypal）
- 使用PostgreSQL資料庫儲存使用者及文章資料

## 功能
- 會員系統功能
  - 註冊、登入、登出
  - 編輯個人資料、修改密碼
  - 會員資格升級功能（付費）
- 首頁功能
  - 顯示所有已發佈之文章
  - 最受歡迎文章排名
- 文章功能
  - 新增、編輯、刪除（軟刪除，會記錄刪除時間，讓文章不可見）文章
  - 設定文章為發佈或草稿狀態
  - 查看自己的所有發佈及草稿狀態文章
  - 文章編輯器（字型、顏色、粗體...）
  - 留言
  - 拍手功能
  - 收藏文章
  - 追蹤作者
  - 查看單一文章時，網址帶有文章標題
- 會員登入、登出、文章建立或修改...等，皆會於頁面上方跳出一次性提醒


## 畫面
### 瀏覽器畫面
![截圖 2024-06-09 首頁（瀏覽器畫面）](https://github.com/TamyTsai/blog-system/assets/97825677/2bde100d-14dc-457e-af6d-c0e1107e0772)

### 行動裝置畫面
![截圖 2024-06-09 行動裝置畫面](https://github.com/TamyTsai/blog-system/assets/97825677/bca21dc5-43f2-458d-8ed7-fabe7b1b626f)


## 安裝
以下皆為於macOS環境運行
### 安裝Ruby
```bash
$ brew install ruby
```
### 安裝Rails v6.1.7.7
```bash
$ gem install rails -v 6.1.7.7
```
### 下載PostgreSQL
```bash
$ brew install postgresql
```
### 建立資料庫
```bash
$ rails db:create
```
### 建立資料表
```bash
$ rails db:migrate
```
### 取得專案
```bash
$ git clone https://github.com/TamyTsai/blog-system.git
```
### 移動到專案內
```bash
$ cd blog-system
```
### 安裝相關套件
```bash
$ bundle install
```
### 環境變數設定
請將config目錄下application.yml.sample重新命名，檔案名稱刪除「.sample」，並依照自身需求設定檔案中之環境變數

### 啟動rails伺服器
```bash
$ rails s
```
### 開啟專案
在瀏覽器網址列輸入以下網址即可看到專案首頁
```bash
http://localhost:3000/
```

## 主要資料夾及檔案說明
- app - 核心程式放置處
- bin - rails、webpack、yarn 基本指令放置處
- config- rails 的基本文件放置處
- db - 定義資料庫綱要（schema）、資料庫遷移（migration）之處
- lib - 自行定義檔案放置處（rake等）
- log - 本專案記錄檔放置處
- public - 本專案靜態檔案 (404、422、500 錯誤顯示畫面)放置處
- tmp - 臨時或暫時用文件放置處
- vender - 第三方文件放置處
- Gemfile - 要安裝 Ruby 的套件放置處
- Gemfile.lock - 當套件放置 /Gemfile 資料夾時，在終端機輸入 bundle install (可簡化為bundle)，會在此生成此套件的基本設定檔
- gitignore - 以 git 做版本控制時，不想被 git 追蹤的檔案名稱放置處
- Rakefile - 用來載入 rake 命令包含的任務

## 專案技術
- HTML
- CSS
  - SCSS
  - RWD
  - Bulma v1.0.1
  - Font Awesome v6.5.2
- JavaScripts
  - ES6
  - AJAX
  - Stimulus.js
- Ruby v2.7.8
  - Rails v6.1.7.7
    - aasm v 5.5.0
    - ActiveStorage v 6.1.7.7
    - babosa v2.0.0
    - devise v4.9.4
    - figaro v1.2.0
    - friendly id v5.5.1
    - Froala editor v4.2.0
    - image processing v1.12.2
    - paranoia v2.6.3
    - turbolinks v5.2.1
- Braintree v4.20.0
- PostgreSQL v1.5.6

## 第三方服務
- Braintree
