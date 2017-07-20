$(document).on('turbolinks:load', function() {
  $('.switchery').each(function(index, elem) {
    elem.remove();
  });

  $('.js-switch').each(function(index, elem) {
    var init = new Switchery(elem);
  });
});
