import { Controller } from "stimulus"
import axios from 'axios'

// 使用axios套件往後端api（/users/:id/follow）打
export default class extends Controller {
  static targets = [ "followButton" ] 
  // 寫了followButtont後，之後就會有一個followButtontTarget方法
  // data-target="user.followButton"

  //       <%= link_to "追蹤", '#', class: 'follow-button',
                                // data: { action: 'user#follow', 
                                // user: @story.user.id, 
                                // target: 'user.followButton' } %>

  follow(event) { // 按下按鈕會觸發的事件 data-action
    event.preventDefault(); // 先停下原本預設行為
    // 比如 點擊 連結路徑＃ 的預設行為 就是 回到頁面頂端

    let user = this.followButtontTarget.dataset.user; // 要 被追蹤的使用者
    // 也可改成currentTarget，因為這裡的 按鈕（data-action） 與 target（data-target）是同一對象？
    // .dataset可以抓到data attribute屬性
    // .user 可以抓到data attribute屬性 

    // 要用rails g controller users建立users控制器（原本的users控制器是跟devise有關的 跟這個不一樣）
    axios.post(`/users/${user}/follow`)
    .then(function(response) {
      let status = response.data.status
      // 抓到stories_controller.rb中 clap aciton回傳的status資料（response.data.status） 指定給 變數status
      // ES6變數寫法
      switch (status){
          case 'sign_in_first': // status 若等於 sign_in_first （表示使用者未登入（此檢查是否登入之 流程控制是在stories_controller.rb做的））
              alert('你必須先登入')
              break;
          default: // status 若非 sign_in_first （表示使用者有登入）
              target.innerHTML = status
              // 改變 畫面上拍手數字 的 內容
              // stories_controller.rb：  render json: {status: story.clap}
              // 會直接抓到 story.clap（story物件（根據網址id被抓出來的 要被拍手的文章） 之 clap欄位 值）
            }
        })
    .catch(function(error) {
        console.log(error)
    })

  }




//   addClap(event) {
//     event.preventDefault(); // 先停下原本預設行為
//     // 比如 點擊 連結路徑＃ 的預設行為 就是 回到頁面頂端
//     let slug = event.currentTarget.dataset.slug;
//     // currentTarget 目前這個按鈕上的連結內容（文章標題）
//     // <a class="clapButton is-size-4 has-text-primary" data-action="story#addClap" data-slug="文章名稱" href="#">
//     let target = this.clapCountTarget
//     // 將 要被操控的目標（畫面上的 拍手數字）指定給 變數target
    
//     // 資料往此路徑打：/stories/:id/clap(.:format)
//     // 打api需要函式庫：axios
//     // 使用PSOT方法 透過axios套件 往 此連結打 API（stories_controller.rb clap方法）
//     // 打過去會有回應（json格式），接著根據回應處理後續動作（拍手功能用正統AJAX寫，留言功能收到的回應則是js，收到後執行該js）
//     // API由後端工程師來寫
//     axios.post(`/stories/${slug}/clap`) // ES6變數串接字串的寫法 // 要去routes設定路徑
//         .then(function(response) {
//             let status = response.data.status
//             // 抓到stories_controller.rb中 clap aciton回傳的status資料（response.data.status） 指定給 變數status
//             // ES6變數寫法
//             switch (status){
//                 case 'sign_in_first': // status 若等於 sign_in_first （表示使用者未登入（此檢查是否登入之 流程控制是在stories_controller.rb做的））
//                     alert('你必須先登入')
//                     break;
//                 default: // status 若非 sign_in_first （表示使用者有登入）
//                     target.innerHTML = status
//                     // 改變 畫面上拍手數字 的 內容
//                     // stories_controller.rb：  render json: {status: story.clap}
//                     // 會直接抓到 story.clap（story物件（根據網址id被抓出來的 要被拍手的文章） 之 clap欄位 值）
//             }
//         })
//         .catch(function(error) {
//             console.log(error)
//         })
        
//     // 如果成功抓到資料，就執行.then後面接的函數
//     // 如果失敗，就執行.catch後面接的函數

//     // stories_controller.rb
//     // def clap # 按下拍手按鈕 的 action
//     //     render json: {status: 'ok'}  ->會傳到 response或error參數 中
//     // end


//     // this.clapCountTarget.innerHTML = 'cch'
//     // .clapCountTarget 為 stimulus的黑魔法
//     // 會抓到拍手數 的 數字
//   }

}