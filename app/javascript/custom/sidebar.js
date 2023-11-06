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
// ! NG: renderした場合、下記は効かなくなる。直接イベントをつけていた要素がなくなるため
document.addEventListener('turbo:load', () => {
  // ¥ event delegationを使ったバイ、正常に動く!
  $(document)
    .off('click')
    .on('click', '.logo-mark', function () {
      $('#sidebar').toggle(0, function () {
        console.log('Toggle completed');
      });
    });
});

// $(document)
//   .off('click', '.logo-mark')
//   .on('click', '.logo-mark', function () {
//     $('#sidebar').toggle(0, function () {
//       console.log('Toggle completed');
//     });
//   });
