class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, presence: { message: "タイトルが未入力です" }, length: { maximum: 30, message: "タイトルの文字数が30文字を超えています" }
  validates :image, presence: { message: "画像ファイルが未入力です" }
end

