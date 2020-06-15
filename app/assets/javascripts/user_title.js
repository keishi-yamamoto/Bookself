document.addEventListener('turbolinks:load', function () {
  // 本棚未所持の場合
  if (document.getElementById('option_choice') == null) {
    document.getElementById('option_new').remove();
  }
  // 巻数の最大値（tdの数）を取得
  maxVol = document.getElementById('title-info').getAttribute('value');
  // 抜け巻数リストを取得
  volShortage = JSON.parse(document.getElementById('title-info').getAttribute('data'));
  // テーブルtd要素
  td = [];
  // 全巻数の所持フラグ
  data = [];
  function setValue(option) {
    for (let i = 1; i <= maxVol; i++) {
      td[ i ] = document.getElementById('number-' + i);
      if (option == 'default') {
        // 抜け巻数リストに含まれていたら未所持状態に変える
        if (volShortage.includes(i)) {
          td[ i ].classList.remove('table-danger');
          td[ i ].classList.remove('table-primary');
          data[ i - 1 ] = 0;
        } else {
          data[ i - 1 ] = 1;
        }
      } else {
        if (volShortage.includes(i)) {
          td[ i ].classList.add('table-danger');
        } else {
          td[ i ].classList.add('table-primary');
        }
        data[ i - 1 ] = 1;
      }
    };
  }
  setValue('default');
  numbers = document.getElementById('numbers')
  numbers.value = JSON.stringify(data);
  // 一括変更ボタン
  changeButton = document.getElementById('change-button')
  changeButton.addEventListener('click', function () {
    if (this.getAttribute('flag') == 0) {
      setValue('change');
      numbers.value = JSON.stringify(data);
      this.setAttribute('flag', 1);
      this.textContent = "元の状態に戻す";
    } else {
      setValue('default');
      numbers.value = JSON.stringify(data);
      this.setAttribute('flag', 0);
      this.textContent = "一括登録";
    }
  })
  // クリックで色と所持しているどうかのvalueを切り替える
  for (let i = 1; i <= maxVol; i++) {
    td[ i ].addEventListener('click', function () {
      if (data[ i - 1 ] == 0) {
        if (volShortage.includes(i)) {
          td[ i ].classList.add('table-danger');
        } else {
          td[ i ].classList.add('table-primary');
        }
        data[ i - 1 ] = 1;
        numbers.value = JSON.stringify(data);
      } else {
        td[ i ].classList.remove('table-primary');
        td[ i ].classList.remove('table-danger');
        data[ i - 1 ] = 0;
        numbers.value = JSON.stringify(data);
      }
    })
  };
  // 追加登録巻数
  endForm = document.getElementById('end-volume');
  endAlert = document.getElementById('end-alert');
  endForm.addEventListener('change', function () {
    if (this.value.match(/[^0-9]+/)) {
      endAlert.classList.remove('is-valid');
      endAlert.textContent = "数字以外が入力されています";
      endAlert.classList.add('is-invalid');
      document.getElementById('submit').disabled = true;
    } else {
      if (this.value == "") {
        endAlert.classList.remove('is-invalid');
        endAlert.classList.remove('is-valid');
        endAlert.textContent = "";
        document.getElementById('submit').disabled = false;
      } else {
        if (this.value <= maxVol) {
          endAlert.classList.add('is-invalid');
          endAlert.classList.remove('is-valid');
          endAlert.textContent = "表の最後の巻数より大きな数字を入力して下さい";
          document.getElementById('submit').disabled = true;
        } else {
          endAlert.classList.add('is-valid');
          endAlert.classList.remove('is-invalid');
          endAlert.textContent = "正しく入力されています";
          document.getElementById('submit').disabled = false;
        }
      }
    }
  })
});