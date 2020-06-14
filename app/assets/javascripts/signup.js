document.addEventListener('turbolinks:load', function () { 
  const button = document.getElementById('submit');
  button.disabled = true;
  const flag = [0,0,0]
  // nameフォームの文字数カウント
  let name = document.getElementById('user_name');
  let count = document.getElementById('name_count');
  name.addEventListener('keyup', function () {
    count.textContent = this.value.length + "/20";
    if(this.value.length <= 20) {
      count.classList.remove('is-invalid');
      count.classList.add('is-valid');
      flag[ 0 ] = 1;
      submit();
    } else {
      count.classList.remove('is-valid');
      count.classEList.add('is-invalid');
      flag[ 0 ] = 0;
      submit();
    }
  });

  // idのバリデーション
  let id = document.getElementById('user_elastic_id');
  let id_text = document.getElementById('id_validation');
  // フォームに変更があった際にajax通信
  id.addEventListener("change", function (e) {
    e.preventDefault();  // デフォルトのイベント（HTMLデータ送信など）を無効にする
    let url = '/users/search_id?id=' + this.value;  //  クエリ形式でパラメータを渡す
    let xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);  // 非同期通信を指定
    xhr.send(null);
    xhr.onreadystatechange = function () {
      // 引数eventでも実現可能
      if (xhr.readyState === 4) {
        if (xhr.status == 200) {
          // 通信成功時の処理
          // フォームのidに対してpresent?メソッドの結果が引数となる
          if (xhr.response == 'false') {
            id_text.classList.remove('is-invalid');
            id_text.classList.add('is-valid');
            flag[ 1 ] = 1;
            submit();
            id_text.textContent = "このIDは使用可能です";
          } else {
            id_text.classList.remove('is-valid');
            id_text.classList.add('is-invalid');
            flag[ 1 ] = 0;
            submit();
            id_text.textContent = "このIDは既に使われています"
          }
        } else {
          console.log("error has occured.XMLHttpRequest.status isn't 200.")
        }
      }
    };
  }, false);

  // emailのバリデーション
  let email = document.getElementById('user_email');
  let email_text = document.getElementById('email_validation');
  // emailの正規表現
  const regexp = /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$/;
  email.addEventListener("change", function (e) {
    e.preventDefault();
    let url = '/users/search_mail?email=' + this.value;
    let xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.send(null);
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        if (xhr.status == 200) {
          if (xhr.response == 'false') {
            // ユニーク判定のあとに正規表現チェック
            if (regexp.test(email.value)) {
              email_text.classList.remove('is-invalid');
              email_text.classList.add('is-valid');
              flag[ 2 ] = 1;
              submit();
              email_text.textContent = "このメールアドレスは使用可能です";
            } else {
              email_text.classList.remove('is-valid');
              email_text.classList.add('is-invalid');
              flag[ 2 ] = 0;
              submit();
              email_text.textContent = "メールアドレスを入力してください"
            }
          } else {
            email_text.classList.remove('is-valid');
            email_text.classList.add('is-invalid');
            flag[ 2 ] = 0;
            submit();
            email_text.textContent = "このメールアドレスは既に使われています"
          }
        } else {
          console.log("error has occured.XMLHttpRequest.status isn't 200.")
        }
      }
    };
  }, false);
  function submit() {
    if (flag[0] == 1 && flag[1] == 1 && flag[2] == 1) {
      button.disabled = false;
    } else {
      button.disabled = true;
    }
  }
});
