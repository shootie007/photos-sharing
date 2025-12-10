require "test_helper"

class OauthTweetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      email: "test@example.com",
      password: "password123"
    )
    sign_in(@user)

    @photo = Photo.new(user: @user, title: "Test Photo")
    @photo.image = fixture_file_upload("test_image.jpg", "image/jpeg")
    @photo.save!
  end

  test "should redirect on authorize" do
    get oauth_authorize_path
    assert_response :redirect
  end

  test "should redirect to photos path when code is missing in callback" do
    get oauth_callback_path
    assert_redirected_to photos_path
  end

  test "should redirect to photos path when access token is missing in create" do
    post photo_tweets_path(@photo)
    assert_redirected_to photos_path
  end
end
