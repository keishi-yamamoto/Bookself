document.addEventListener('turbolinks:load', function () {
  optionNew = document.getElementById('option_new');
  formNew = document.getElementsByClassName('form_new');
  optionChoice = document.getElementById('option_choice');
  formChoice = document.getElementsByClassName('form_choice');
  optionChoice.checked = true;
  optionChoice.addEventListener('click', function () {
    formChoice.disabled = false;
    formNew.disabled = true;
  });
  optionNew.addEventListener('click', function () {
    formNew.disabled = false;
    formChoice.disabled = true;
  })
});