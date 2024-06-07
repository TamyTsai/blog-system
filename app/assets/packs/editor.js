import FroalaEditor from "froala-editor";
// $ yarn add --dev froala-editor後  node_modules下有froala-editor資料夾

// 非全站都會需要用到，所以不是去application.js import，而是需要時再抓出來用即可
document.addEventListener('DOMContentLoaded', function(event){
    // 監聽DOM元素已載入事件，已載入後 就執行函數
    let editor = new FroalaEditor('#stroy_content')
    // 抓出 編輯文章頁面中 的 文章內容輸入框

})