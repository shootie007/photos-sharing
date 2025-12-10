class User < ApplicationRecord
  has_secure_password
  has_many :photos, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  def self.authenticate_by_email_case_insensitive(email:, password:)
    # DBに保存するメールアドレスはユーザーの入力値を保持しておいた方が後々問題になりにくいため、メールアドレスの大文字小文字無視は、検索ロジックでカバーする
    user = find_by("LOWER(email) = ?", email.to_s.downcase)
    user && authenticate_by(email: user.email, password: password)
  end
end

