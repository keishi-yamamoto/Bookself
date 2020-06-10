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
    formNew.disabled = true;
    optionChoice.addEventListener('click', function () {
      formChoice.disabled = false;
      formNew.disabled = true;
    });
    optionNew.addEventListener('click', function () {
      formNew.disabled = false;
      formChoice.disabled = true;
    })
  }
  // 巻数の範囲チェック
  let flag = [];
  startForm = document.getElementById('start_vol');
  startAlert = document.getElementById('start-alert');
  endForm = document.getElementById('end_vol');
  endAlert = document.getElementById('end-alert');
  startForm.addEventListener('change', function () {
    if (this.value.match(/[^0-9]+/)) {
      startAlert.textContent = "数字以外が入力されています";
      startAlert.classList.add('is-invalid');
      flag[ 0 ] = 0;
    } else {
      startAlert.classList.remove('is-invalid');
      startAlert.textContent = this.value + "巻から";
      flag[ 0 ] = 1;
      numValid();
    }
  });
  endForm.addEventListener('change', function () {
    if (this.value.match(/[^0-9]+/)) {
      endAlert.textContent = "数字以外が入力されています";
      endAlert.classList.add('is-invalid');
      flag[ 1 ] = 0;
    } else {
      endAlert.classList.remove('is-invalid');
      endAlert.textContent = this.value + "巻まで";
      flag[ 1 ] = 1;
      numValid();
    }
  })
  // 大小関係のチェック、submitボタン押せるようにする
  function numValid() {
    numAlert = document.getElementById('number-alert');
    button = document.getElementById('submit');
    if (flag[0] == 1 && flag[1] == 1) {
      if (startForm.value > endForm.value) {
        numAlert.classList.remove('is-valid');
        numAlert.classList.add('is-invalid');
        numAlert.textContent = "終了巻数は開始巻数より大きい数字にしてください"
      } else {
        numAlert.classList.remove('is-invalid');
        numAlert.classList.add('is-valid');
        numAlert.textContent = "正しく入力されています"
        button.disabled = false;
      }
    }
  }
});