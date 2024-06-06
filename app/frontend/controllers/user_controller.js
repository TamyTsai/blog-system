import { Controller } from "stimulus"
import axios from 'axios'

// 使用axios套件往後端api（/users/:id/follow）打
export default class extends Controller {
  static targets = [ "followButton", "bookmark" ] 
  // 寫了followButtont後，之後就會有一個followButtonTarget方法
  // data-target="user.followButton"

  // 追蹤按鈕
  // <%= link_to "追蹤", '#', class: 'follow-button',
                          // data: { action: 'user#follow', 
                          // user: @story.user.id, 
                          // target: 'user.followButton' } %>

  // <!-- 書籤收藏按鈕 -->
  // <%= link_to '#', class: 'bookmark-button', data: { action: 'user#bookmark', slug: @story.slug } do %>
  //   <i class="fa-regular fa-bookmark" data-target="user.bookmark"></i>
  //   <!-- data-target為 觸發data-action成功後 要操控的對象 -->
  // <% end %>

  follow(event) { // 按下按鈕會觸發的事件 data-action
    event.preventDefault(); // 先停下原本預設行為
    // 比如 點擊 連結路徑＃ 的預設行為 就是 回到頁面頂端

    let user = this.followButtonTarget.dataset.user; // 要 被追蹤的使用者
    // 也可改成currentTarget，因為這裡的 按鈕（data-action） 與 target（data-target）是同一對象？
    // .dataset可以抓到data attribute屬性
    // .user 可以抓到data attribute屬性 
    let button = this.followButtonTarget;
    // 將 要被操控的目標（追蹤按鈕）指定給 變數button

    // 要用rails g controller users建立users控制器（原本的users控制器是跟devise有關的 跟這個不一樣）
    // 用axios函式庫做post post到後端
    axios.post(`/api/users/${user}/follow`)
         .then(function(response) {
            let status = response.data.status
            // 抓到controller.rb中 follow aciton回傳的status資料（response.data.status） 指定給 變數status
            switch (status) {
                case 'sign_in_first': // status 若等於 sign_in_first （表示使用者未登入（此檢查是否登入之 流程控制是在controller.rb做的））
                    alert('你必須先登入')
                    break;
                default: // status 若非 sign_in_first （表示使用者有登入）
                    button.innerHTML = status
                    // 改變 追蹤按鈕 的 內容（按鈕上面的字）
                    // controller.rb：  render json: {status: current_user.follow!(@user)}
                    // current_user.follow!(@user)會回傳「追蹤」（退追後 還沒追蹤）或「追蹤中」（開始追蹤）
                  }
            })
         .catch(function(error) {
              console.log(error)
            })

  }

  bookmark(event) {
    event.preventDefault()

    let link = event.currentTarget; // 把按下去的超連結抓出來
    let slug = link.dataset.slug; // 目前這個按鈕上的連結內容 的 文章標題 部分

    axios.post(`/api/stories/${slug}/bookmark`)
         .then(function(response) {
            let status = response.data.status
            // 抓到controller.rb中 follow aciton回傳的status資料（response.data.status） 指定給 變數status
            switch (status) {
                case 'sign_in_first': // status 若等於 sign_in_first （表示使用者未登入（此檢查是否登入之 流程控制是在controller.rb做的））
                    alert('你必須先登入')
                    break;
                default: // status 若非 sign_in_first （表示使用者有登入）
                    button.innerHTML = status
                    // 改變 追蹤按鈕 的 內容（按鈕上面的字）
                    // controller.rb：  render json: {status: current_user.follow!(@user)}
                    // current_user.follow!(@user)會回傳「追蹤」（退追後 還沒追蹤）或「追蹤中」（開始追蹤）
                  }
            })
         .catch(function(error) {
              console.log(error)
            })
  }

}