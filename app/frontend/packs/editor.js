import FroalaEditor from "froala-editor";
// $ yarn add --dev froala-editor後  node_modules下有froala-

// 引入FroalaEditor的 plugin外掛
import 'froala-editor/js/languages/zh_tw.js'; // 提供語言切換選項（要在以FroalaEditor類別建立實體物件 傳入初始參數時 設定）
import 'froala-editor/js/plugins/table.min.js'; // 表格功能
import 'froala-editor/js/plugins/colors.min.js'; // 設定顏色功能
import 'froala-editor/js/plugins/draggable.min.js'; // 可以拖曳
import 'froala-editor/js/plugins/font_size.min.js'; // 可調字型尺寸
import 'froala-editor/js/plugins/fullscreen.min.js'; // 可全螢幕編輯
import 'froala-editor/js/plugins/image.min.js'; // 可上傳照片
import 'froala-editor/js/plugins/link.min.js'; // 可編輯連結
import 'froala-editor/js/plugins/lists.min.js'; // 可編輯列表
import 'froala-editor/js/plugins/quote.min.js'; // 引言功能
import 'froala-editor/js/plugins/video.min.js'; // 上傳影片功能



// 非全站都會需要用到，所以不是去application.js import，而是需要時再抓出來用即可
document.addEventListener('turbolinks:load', function(event){ 
    // 監聽DOM元素已載入事件，已載入後 就執行函數
    // 'DOMContentLoaded'為一般的html監聽事件
    // trubolinks有自己的事件
    // 'turbolinks:load'表示讓turbolinks管理載入的東西
    let editor = new FroalaEditor('#stroy_content', { // options
        language: 'zh_tw', // 設定語言為繁體中文
        //spellcheck: false // 關掉拼字檢查
        imageUploadURL: '/api/upload_image' // 編輯器中 上傳的圖片 要打的後端路徑（用POST方法打api路徑）
        // https://froala.com/wysiwyg-editor/docs/concepts/image/upload/
        // imageUploadURL is the URL where the upload request is being made.
    })
    // 抓出 編輯文章頁面中 的 文章內容輸入框 並傳入以FroalaEditor類別所建立的實體物件中

})

// 每次進到 文章編輯頁面時，都要重新整理一次，才會出現 文字編輯器？
// 因為rails 預設使用 Turbo link快取
// 解決方法：讓事件監聽者監聽'turbolinks:load'事件，而非'DOMContentLoaded'（一般的html監聽事件）