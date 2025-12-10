require "test_helper"
require "stringio"

class PhotoTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      email: "test@example.com",
      password: "password123"
    )
  end

  test "title should be present" do
    photo = Photo.new(user: @user)
    photo.image.attach(
      io: StringIO.new("fake image content"),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )
    assert_not photo.valid?
  end

  test "title should not exceed 30 characters" do
    photo = Photo.new(
      user: @user,
      title: "a" * 31
    )
    photo.image.attach(
      io: StringIO.new("fake image content"),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )
    assert_not photo.valid?
  end

  test "title should be valid with 30 characters" do
    photo = Photo.new(
      user: @user,
      title: "a" * 30
    )
    photo.image.attach(
      io: StringIO.new("fake image content"),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )
    assert photo.valid?
  end

  test "image should be present" do
    photo = Photo.new(
      user: @user,
      title: "Test Photo"
    )
    assert_not photo.valid?
  end
end
