require 'test_helper'

class Users::BookShelvesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_book_shelves_index_url
    assert_response :success
  end

  test "should get show" do
    get users_book_shelves_show_url
    assert_response :success
  end

end
