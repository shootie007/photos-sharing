require "test_helper"
require "stringio"

class PhotosControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      email: "test@example.com",
      password: "password123"
    )
    sign_in(@user)
  end

  test "should get index" do
    get photos_path
    assert_response :success
  end

  test "should get new" do
    get new_photo_path
    assert_response :success
  end

  test "should create photo with valid attributes" do
    image = fixture_file_upload("test_image.jpg", "image/jpeg")
    assert_difference "Photo.count", 1 do
      post photos_path, params: {
        photo: {
          title: "Test Photo",
          image: image
        }
      }
    end
    assert_redirected_to photos_path
  end

  test "should not create photo without title" do
    image = fixture_file_upload("test_image.jpg", "image/jpeg")
    assert_no_difference "Photo.count" do
      post photos_path, params: {
        photo: {
          title: "",
          image: image
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create photo without image" do
    assert_no_difference "Photo.count" do
      post photos_path, params: {
        photo: {
          title: "Test Photo"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should redirect to root path when not authenticated" do
    delete logout_path

    get photos_path
    assert_redirected_to root_path
  end
end

