require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      email: "test@example.com",
      password: "password123"
    )
  end

  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should redirect to photos path with valid credentials" do
    post login_path, params: {
      email: @user.email,
      password: "password123"
    }
    assert_redirected_to photos_path
    assert_equal @user.id, session[:user_id]
  end

  test "should return unprocessable entity with wrong password" do
    post login_path, params: {
      email: @user.email,
      password: "wrongpassword"
    }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should return unprocessable entity with non-existent email" do
    post login_path, params: {
      email: "nonexistent@example.com",
      password: "password123"
    }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should redirect to root path on logout" do
    post login_path, params: {
      email: @user.email,
      password: "password123"
    }

    delete logout_path
    assert_redirected_to root_path
  end

  test "should clear user id from session on logout" do
    post login_path, params: {
      email: @user.email,
      password: "password123"
    }
    assert_equal @user.id, session[:user_id]

    delete logout_path
    assert_nil session[:user_id]
  end
end
