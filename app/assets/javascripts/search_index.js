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
    // 結果を表示する
    row[ i ].addEventListener('click', function (e) {
      e.preventDefault();
      search(i);
    });
  };
  const test = document.getElementById('book-title-2');
  function search(i) {
    // モーダルの表示文
    const body = document.getElementById('modal-text');
    const url = '/search/book_title?title=' + data[ i ];
    const xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.send(null);
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        if (xhr.status == 200) {
          const parentDiv = document.getElementById('modal-body');
          // リロードせずに再度modalを開いた場合のための初期化
          while (parentDiv.firstChild) parentDiv.removeChild(parentDiv.firstChild);
          header_tag_1 = document.createElement('h5');
          header_content_1 = document.createTextNode('登録済タイトル')
          header_tag_1.appendChild(header_content_1);
          header_tag_1.setAttribute('id', 'header-1');
          parentDiv.insertBefore(header_tag_1, parentDiv.firstChild);
          // 書籍が登録されていなかった場合
          if (xhr.response == '[]') {
            titleTag = document.createElement('p');
            titleContent = document.createTextNode('見つかりませんでした')
            titleTag.appendChild(titleContent);
            titleTag.setAttribute('class', 'is-invalid');
            parentDiv.insertBefore(titleTag, header_tag_1.nextSibling);
          } else {
            // 検索結果の数だけタグを追加
            const titleTag = [];
            const titleContent = [];
            for (let n = 0; n < JSON.parse(xhr.response).length; n++) {
              titleTag[ n ] = document.createElement('p');
              // json形式で取得した後配列に直す
              titleContent[ n ] = document.createTextNode(JSON.stringify(JSON.parse(xhr.response)[ n ][ "name" ]).replace(/\"/g, ""));
              titleTag[ n ].appendChild(titleContent[ n ]);
              titleTag[ n ].setAttribute('class', 'title-exist');
              // 見つかった登録書籍のidをdata属性に追加
              titleTag[ n ].setAttribute('data', JSON.stringify(JSON.parse(xhr.response)[ n ][ "id" ]).replace(/\"/g, ""));
              parentDiv.insertBefore(titleTag[ n ], header_tag_1.nextSibling);
            }
          }
          // 新規登録用タイトルタグ
          header_tag_2 = document.createElement('h5');
          header_content_2 = document.createTextNode('新しく登録する(シリーズ名を選んでください)')
          header_tag_2.appendChild(header_content_2);
          header_tag_2.setAttribute('id', 'header2');
          parentDiv.appendChild(header_tag_2);
          // そのままのタイトル,区切りの数だけ選択肢提示する
          row_title = ""
          for (let m = 0; m < data[ i ].length; m++) {
            title_row = document.createElement('p');
            // 複数ワードからなる場合は半角スペースで区切る
            if (m != 0) {
              row_title += " ";
            }
            row_title += (data[ i ])[ m ];
            content = document.createTextNode(row_title);
            title_row.appendChild(content);
            title_row.setAttribute('class', 'title-new');
            parentDiv.appendChild(title_row);
          }
          // Bootstrapのmodal起動(jQuery必要)
          $('#Modal').modal('show');
          // 各タイトルにリンク付与
          titles = document.getElementsByClassName('title-exist');
          for (let o = 0; o < titles.length; o++) {
            title = titles[ o ];
            title.addEventListener('click', function () {
              window.location.href =
                '/user_titles/new?id=' + this.getAttribute('data');
            });
          }
          titlesNew = document.getElementsByClassName('title-new');
          for (let p = 0; p < titlesNew.length; p++) {
            title = titlesNew[ p ];
            title.addEventListener('click', function () {
              window.location.href =
                '/user_titles/new?title=' + this.textContent
                + '&row_title=' + document.getElementById('book-title-' + i).textContent
                + '&author=' + document.getElementById('book-author-' + i).textContent
                + '&publisher=' + document.getElementById('book-publisher-' + i).textContent;
            });
          }
        } else {
          console.log("error has occured.XMLHttpRequest.status isn't 200.");
        }
      }
    }
  };
});