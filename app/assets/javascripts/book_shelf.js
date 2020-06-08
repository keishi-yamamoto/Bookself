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
});