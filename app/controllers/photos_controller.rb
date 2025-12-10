class PhotosController < ApplicationController
  def index
    @photos = current_user.photos.order(created_at: :desc)
  end

  def new
    @photo = current_user.photos.build
  end

  def create
    @photo = current_user.photos.build(photo_params)

    if @photo.save
      redirect_to photos_path, notice: "写真をアップロードしました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
