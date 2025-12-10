class OauthTweetsController < ApplicationController
  def authorize
    client = External::TweetsClient.new
    oauth_url = client.oauth_authorize_url(redirect_uri: oauth_callback_url)
    redirect_to oauth_url, allow_other_host: true
  end

  def callback
    code = params[:code]

    unless code
      redirect_to photos_path, alert: "認可コードが取得できませんでした"
      return
    end

    client = External::TweetsClient.new
    access_token = client.fetch_access_token(
      code: code,
      redirect_uri: oauth_callback_url
    )

    if access_token
      session[:oauth_access_token] = access_token
      redirect_to photos_path, notice: "OAuth認証が完了しました"
    else
      redirect_to photos_path, alert: "アクセストークンの取得に失敗しました"
    end
  end

  def create
    access_token = session[:oauth_access_token]

    unless access_token
      redirect_to photos_path, alert: "OAuth認証が必要です"
      return
    end

    photo = current_user.photos.find(params[:photo_id])
    image_url = url_for(photo.image)

    client = External::TweetsClient.new
    if client.post_tweet(
      access_token: access_token,
      text: photo.title,
      url: image_url
    )
      redirect_to photos_path, notice: "ツイートを投稿しました"
    else
      redirect_to photos_path, alert: "ツイートの投稿に失敗しました"
    end
  end
end

