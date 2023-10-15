// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails';
import 'controllers';

// ===== ここを追加 =====
import jquery from 'jquery';
window.$ = jquery;

$(function () {
  console.log('sales_appointment/app/javascript/application.jsに新しく作成したjsファイル名を記載する。');
});

import './custom/sidebar.js';
