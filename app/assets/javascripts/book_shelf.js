document.addEventListener('turbolinks:load', function () {
  // search_index.jsと同様にtbody.trをクリックした際にページ遷移
  // book_shelves#show,nil/user_titles#indexにて適用される
  const rows = document.getElementsByClassName('user_title');
  const row = [];
  const tag = [];
  const data = [];
  for (let i = 0; i < rows.length; i++) {
    row[ i ] = document.getElementById('row-' + i);
    tag[ i ] = document.getElementById('tag-info-' + i);
    data[ i ] = tag[ i ].getAttribute('data-id');
    row[ i ].addEventListener('click', function (e) {
      e.preventDefault();
      search(i);
    });
  }
  function search(i) {
    window.location.href = '/user_titles/' + data[ i ];
  }
  const rowTitles = document.getElementsByClassName('title_all');
  const rowTitle = [];
  const dataTitle = [];
  // 初期設定
  for (let i = 0; i < rowTitles.length; i++) {
    rowTitle[ i ] = document.getElementById('title-' + i);
    // 現在の登録されている本棚が表示している本棚かどうか
    if (rowTitle[ i ].getAttribute('class').includes('table-success')) {
      dataTitle[ i ] = [ parseInt(rowTitle[ i ].getAttribute('data')), 1 ];
    } else {
      dataTitle[ i ] = [ parseInt(rowTitle[ i ].getAttribute('data')), 0 ];
    }
  }
  numbers = document.getElementById('numbers');
  numbers.value = JSON.stringify(dataTitle);
  for (let i = 0; i < rowTitles.length; i++) {
    rowTitle[ i ].addEventListener('click', function () {
      if (dataTitle[ i ][ 1 ] == 0) {
        this.classList.add('table-success');
        dataTitle[ i ][ 1 ] = 1;
        numbers.value = JSON.stringify(dataTitle);
      } else {
        this.classList.remove('table-success');
        dataTitle[ i ][ 1 ] = 0;
        numbers.value = JSON.stringify(dataTitle);
      }
    });
  }
});