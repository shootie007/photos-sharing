require "net/http"

class OauthController < ApplicationController
  OAUTH_BASE_URL = "http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com"
  CLIENT_ID = Rails.application.credentials.oauth[:client_id]
  CLIENT_SECRET = Rails.application.credentials.oauth[:client_secret]
  RESPONSE_TYPE = "code"
  GRANT_TYPE = "authorization_code"
  SCOPE = "write_tweet"

  def authorize
    oauth_uri = URI("#{OAUTH_BASE_URL}/oauth/authorize")
    oauth_uri.query = URI.encode_www_form(
      client_id: CLIENT_ID,
      response_type: RESPONSE_TYPE,
      redirect_uri: oauth_callback_url,
      scope: SCOPE
    )

    redirect_to oauth_uri.to_s, allow_other_host: true
  end

  def callback
    code = params[:code]

    unless code
      redirect_to photos_path, alert: "認可コードが取得できませんでした"
      return
    end

    access_token = fetch_access_token(code)

    if access_token
      session[:oauth_access_token] = access_token
      redirect_to photos_path, notice: "OAuth認証が完了しました"
    else
      redirect_to photos_path, alert: "アクセストークンの取得に失敗しました"
    end
  end

  private

  def fetch_access_token(code)
    token_uri = URI("#{OAUTH_BASE_URL}/oauth/token")

    http = Net::HTTP.new(token_uri.host, token_uri.port)
    request = Net::HTTP::Post.new(token_uri.path)
    request.set_form_data(
      code: code,
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      redirect_uri: oauth_callback_url,
      grant_type: GRANT_TYPE
    )

    response = http.request(request)

    if response.code == "200"
      Rails.logger.info "OAuth token request Success."
      json_response = JSON.parse(response.body)
      json_response["access_token"]
    else
      Rails.logger.error "OAuth token request failed: status=#{response.code}, body=#{response.body}"
      nil
    end
  end
end
