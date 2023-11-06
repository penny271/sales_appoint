// document.addEventListener('turbo:load', function () {
//   console.log('appointment.js...');
//   $('#service_category_select').on('change', function () {
//     $(this).closest('form').submit();
//   });
// });

document.addEventListener('turbo:load', function () {
  console.log('appointment.js...');
  $('#test_submit').on('click', function () {
    $(this).closest('form').submit();
  });
});
