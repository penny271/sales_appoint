// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails';
import 'controllers';

// ===== ここを追加 =====
import jquery from 'jquery';
window.$ = jquery;

$(function () {
  console.log('sales_appointment/app/javascript/application.jsに新しく作成したjsファイル名を記載する。');
  console.log('config/importmap.rb.に読み込ませたいjsファイル or jsファイルの入ったディレクトリを記載する。');
});

// ! NG 開発環境では動くが、本番では動かない - compileされる前の場所を参照してしまうため
// import './custom/sidebar.js';
// import './custom/test.js';

// ¥ production用の書き方
// import 'custom/test';
import 'custom/sidebar';
