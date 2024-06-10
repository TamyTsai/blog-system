// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// 這三個目錄（app lib vendor 下的 assets），在預設情況下這三個資料夾的東西是共通的(因為都會被打包成一個檔案)
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require jquery
// require jquery_ujs
//= require turbolinks
//= require_tree .

// 其中的require jquery和require jquery_ujs會載入JQuery和Rails的JQuery adapater，這是因為我們在Gemfile中有裝jquery-rails這個套件，所以這裡可以讀取的到。
// require turbolinks在上一章有提到。而require_tree .會載入這個目錄下的所有JavaScript檔案。
// 總之，這個manifest的最後輸出結果就是通通壓縮成一個application.js檔案。


// Bulma漢堡選單js
// https://bulma.io/documentation/components/navbar/
document.addEventListener('turbolinks:load', () => { // Rails 6 中Turbo links預設為開啟 所以如果用 DOMContentLoaded 可能沒辦法間聽到正確之事件，要改用turbolinks:load

  // Get all "navbar-burger" elements
  const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Add a click event on each of them
  $navbarBurgers.forEach( el => {
    el.addEventListener('click', () => {

      // Get the target from the "data-target" attribute
      const target = el.dataset.target;
      const $target = document.getElementById(target);

      // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
      el.classList.toggle('is-active');
      $target.classList.toggle('is-active');

    });
  });

});

// 提醒視窗叉叉功能
document.addEventListener('turbolinks:load', () => {
  (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
    const $notification = $delete.parentNode;

    $delete.addEventListener('click', () => {
      $notification.parentNode.removeChild($notification);
    });
  });
});