document.addEventListener('turbolinks:load', function () {
  // テーブルの行数取得
  const rows = document.getElementsByClassName('item');
  // それぞれの行クリックされた際にajax通信
  const row = [];
  const tag = [];
  const data = [];
  for (let i = 0; i < rows.length; i++) {
    // tbodyのtr
    row[ i ] = document.getElementById('row-' + i);
    // html内に埋め込んだタイトル情報
    tag[ i ] = document.getElementById('tag-info-' + i);
    data[ i ] = JSON.parse(tag[ i ].getAttribute('data-title'));
    row[ i ].addEventListener('click', function (e) {
      e.preventDefault();
      console.log('/search/book_title?title=' + data[ i ])
      search('/search/book_title?title=' + data[ i ]);
    });
  };
  function search(url) {
    const xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.send(null);
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        if (xhr.status == 200) {
          if (xhr.response == 'false') {

          } else {

          }
        } else {
          console.log("error has occured.XMLHttpRequest.status isn't 200.");
        }
      }
    }
  };

});