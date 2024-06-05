import { Controller } from "stimulus"
// 可在此集中管理action
// UJS
import axios from 'axios'
// $ yarn add axios
// 安裝後，axios會在node_modules的axios資料夾下

export default class extends Controller {
  static targets = [ "clapCount" ] 
  // 寫了clapCount後，之後就會有一個clapCountTarget方法
  // <span class="clapCount" data-target="story.clapCount">0</span>

  addClap(event) {
    event.preventDefault(); // 先停下原本預設行為
    // 比如 點擊 連結路徑＃ 的預設行為 就是 回到頁面頂端
    let slug = event.currentTargert.dataset.slug;
    // currentTarget 目前這個按鈕上的連結內容（文章標題）
    // <a class="clapButton is-size-4 has-text-primary" data-action="story#addClap" data-slug="文章名稱" href="#">
    
    // 資料往此路徑打：/stories/:id/clap(.:format)
    // 打api需要函式庫：axios
    axios.post(`/stories/${slug}/clap`) // ES6變數串接字串的寫法
        .then(function(response) {
            console.log(response.data)
        })
        .catch(function(error) {
            console.log(error)
        })
    // 如果成功抓到資料，就執行.then後面接的函數
    // 如果失敗，就執行.catch後面接的函數


    // this.clapCountTarget.innerHTML = 'cch'
    // .clapCountTarget 為 stimulus的黑魔法
    // 會抓到拍手數 的 數字
  }
}