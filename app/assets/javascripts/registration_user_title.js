document.addEventListener('turbolinks:load', function () {
  // 本棚が存在するかどうかviewにて表示分岐させている
  if (document.getElementById('option_choice') == null) {
    document.getElementById('option_new').remove();
  } else {
    optionNew = document.getElementById('option_new');
    formNew = document.getElementById('form-new');
    optionChoice = document.getElementById('option_choice');
    formChoice = document.getElementById('form-choice');
    optionChoice.checked = true;
    formNew.readonly = true;
    optionChoice.addEventListener('click', function () {
      formChoice.disabled = true;
      formNew.disabled = true;
    });
    optionNew.addEventListener('click', function () {
      formNew.disabled = true;
      formChoice.disabled = true;
    })
  }
});