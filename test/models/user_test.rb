require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      email: "test@example.com",
      password: "password123"
    )
  end

  test "email should be present" do
    user = User.new(password: "password123")
    assert_not user.valid?
  end

  test "email should be unique" do
    duplicate_user = User.new(email: @user.email, password: "password123")
    assert_not duplicate_user.valid?
  end

  test "email uniqueness should be case insensitive" do
    duplicate_user = User.new(email: @user.email.upcase, password: "password123")
    assert_not duplicate_user.valid?
  end

  test "password should be required" do
    user = User.new(email: "new@example.com")
    assert_not user.valid?
  end

  test "authenticate_by_email_case_insensitive should authenticate with correct credentials" do
    authenticated_user = User.authenticate_by_email_case_insensitive(
      email: @user.email,
      password: "password123"
    )
    assert_equal @user, authenticated_user
  end

  test "authenticate_by_email_case_insensitive should authenticate with uppercase email" do
    authenticated_user = User.authenticate_by_email_case_insensitive(
      email: @user.email.upcase,
      password: "password123"
    )
    assert_equal @user, authenticated_user
  end

  test "authenticate_by_email_case_insensitive should authenticate with lowercase email" do
    user = User.create!(
      email: "UPCASETEST@EXAMPLE.COM",
      password: "password123"
    )
    authenticated_user = User.authenticate_by_email_case_insensitive(
      email: "upcasetest@example.com",
      password: "password123"
    )
    assert_equal user, authenticated_user
  end

  test "authenticate_by_email_case_insensitive should return nil with wrong password" do
    authenticated_user = User.authenticate_by_email_case_insensitive(
      email: @user.email,
      password: "wrongpassword"
    )
    assert_nil authenticated_user
  end

  test "authenticate_by_email_case_insensitive should return nil with non-existent email" do
    authenticated_user = User.authenticate_by_email_case_insensitive(
      email: "nonexistent@example.com",
      password: "password123"
    )
    assert_nil authenticated_user
  end

  test "should have many photos" do
    assert_respond_to @user, :photos
  end
end
