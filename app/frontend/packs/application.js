// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "controllers"
// 會去找javascript > controllers > index.js
// 另外一個叫stimulus的框架

// import 'bulma'
// 會到node_modules中找相對應的模組出來
// 在此js檔案 import了一個css
// bulma css 被打包到js中
// 對webpacker來說，所有圖片、字型、css等 都是js
// bulma跟樣式有關，所以新開一個檔案去引入比較好（可一眼看出檔案中所要import的東西都跟樣式有關，不是js）

import '../stylesheets'
// ..表示上一層資料夾
// 如果沒有明確寫到檔案，只有寫到目錄，js慣例會去找該路徑資料夾下名為index的檔案

// stories.scss 被引進 application.scss 被引進 index.js
// bulma 被引進 index.js
// application.js 引入上面所有
