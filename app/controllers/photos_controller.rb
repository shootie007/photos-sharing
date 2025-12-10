class PhotosController < ApplicationController
  def index
    @photos = current_user.photos.order(created_at: :desc)
  end
end

