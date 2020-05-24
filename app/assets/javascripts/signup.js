document.addEventListener('turbolinks:load', function () { 
  // ユーザネームの文字数リアルタイム表示
  const name = document.getElementById('user_name');
  const count = document.getElementById('name_count');
  name.addEventListener('keyup', function () {
    count.innerHTML = this.value.length + "/20";
  });

  // elastic_idのリアルタイムバリデーション
  const id = document.getElementById('user_elastic_id');
  const msg = document.getElementById('valid_id');
  id.addEventListener('blur', function () {
    // フォーカスが外れた際の値を送信するparameterとする
    let query = this.value;
    console.log('id = ' + query);
    Rails.ajax({
    });
  });
});
