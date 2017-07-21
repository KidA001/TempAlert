function phoneInput(event) {
  if (event.keyCode == 8) return;
  formatPhoneInput(event.currentTarget);
};

function formatPhoneInput(target) {
  var phoneString = target.value.replace(/\D/g, "");

  if (phoneString.length >= 6) {
    phoneString = phoneString.substr(0,6) + "-" + phoneString.substr(6);
  }

  if (phoneString.length >= 3) {
    phoneString = "(" + phoneString.substr(0,3) + ") " + phoneString.substr(3);
  }

  setInputValue(target, phoneString);
}

function setInputValue(input, value) {
  var startOffset = input.value.length - input.selectionStart;
  var endOffset = input.value.length - input.selectionEnd;
  input.value = value;
  input.setSelectionRange(value.length - startOffset, value.length - endOffset);
};

$(document).on('turbolinks:load', function() {
  formatPhoneInput(document.getElementById("phone"));

  $('.js-switch').each(function(index, elem) {
    var init = new Switchery(elem, { size: 'large', secondaryColor: '#efefef', speed: '0.5s' });
  });
});
