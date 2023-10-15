// console.log("object :>>");

// ! NG 別ページから移動して下記を実行しようとしても発火しない
// $(function () {
//   $(".logo-mark").on("click", function () {
//     console.log("abc");
//     // $("#sidebar").toggle("hidden");
//     $("#sidebar").toggle("lg:hidden");
//   });
// });
import $ from 'jquery';

//- 青木 ★要更新 - 20231015
// ¥ turbo:loadイベントは、Turboがページを読み込むたびに発生します。
document.addEventListener('turbo:load', () => {
  $('.logo-mark')
    .off('click')
    .on('click', function () {
      $('#sidebar').toggle('lg:hidden');
    });
});
