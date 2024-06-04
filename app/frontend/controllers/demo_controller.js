//  $ rails webpacker:install:stimulus 

// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

// // HTML from anywhere
// <div data-controller="hello">
// <input data-hello-target="name" type="text">
//   
// <button data-action="click->hello#greet">
//   Greet
// </button>
// 
// <span data-hello-target="output">
// </span>
// </div> 
// data-controller data-target data-action 類似 rails 的 controller中有很多action
// -->
// -----------
// // hello_controller.js
// import { Controller } from "stimulus" 從stimulus這個框架 import一個controller
// 
// export default class extends Controller { 寫一個class繼承他
// static targets = [ "name", "output" ] 寫了output後，之後就會有一個outputTarget方法（name也是，出現nameTarget）
// 
// greet() {
// this.outputTarget.textContent =
//   `Hello, ${this.nameTarget.value}!`
//   }
// } 

import { Controller } from "stimulus"

// 可在此集中管理action
// UJS
export default class extends Controller {
  static targets = [ "content" ] 
  // 寫了content後，之後就會有一個contentTarget方法
  // <input type="text" data-target="demo.content">

  connect() { // connet()表示 當 html頁面div接到demo controller時（<div data-controller='demo'>），會做的第一件事（亦即connet函式在html掛載data-controller='demo'時，被觸發）
    console.log(this.contentTarget)
    // 印出<input type="text" data-target="demo.content">（因為沒打.value，所以會印出整串html標籤）
  }

  // <button data-action="demo#pushme">按我</button>
  pushme(){
    let content = this.contentTarget.value
    // <input type="text" data-target="demo.content">，故<input type="text" data-target="demo.content">會抓到該輸入框的值
    console.log(content)
    // this.contentTarget.textContent =
    // `${content}!` // ES6的變數串接字串寫法
  }

  pushit() {
    console.log(this.contentTarget.value)
    // <input type="text" data-target="demo.content"> 會抓到該輸入框的值
  }
}
