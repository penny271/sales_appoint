// document.addEventListener('turbo:load', function () {
//   console.log('appointment.js...');
//   $('#service_category_select').on('change', function () {
//     // $(this).closest('form').submit();
//     $(this).closest('form').requestSubmit();
//   });
// });

document.addEventListener('turbo:load', function () {
  console.log('appointment.js... - change');
  document.getElementById('service_category_select').addEventListener('change', function () {
    let form = this.closest('form');
    form.requestSubmit();
  });
});

// document.addEventListener('turbo:load', function () {
//   console.log('appointment.js...');
//   $('#test_submit').on('click', function () {
//     $(this).closest('form').submit();
//   });
// });
