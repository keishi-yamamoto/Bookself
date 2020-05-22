document.addEventListener('turbolinks:load', function () { 
  let name = document.getElementById('user_name');
  let count = document.getElementById('name_count');
  name.addEventListener('keyup', function () {
    count.textContent = this.value.length + "/20";
  });
});
