class OauthController < ApplicationController
  OAUTH_AUTHORIZE_URL = "http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/oauth/authorize"
  CLIENT_ID = Rails.application.credentials.oauth[:client_id]
  RESPONSE_TYPE = "code"
  SCOPE = "write_tweet"

  def authorize
    oauth_uri = URI(OAUTH_AUTHORIZE_URL)
    oauth_uri.query = URI.encode_www_form(
      client_id: CLIENT_ID,
      response_type: RESPONSE_TYPE,
      redirect_uri: "http://localhost:3000/oauth/callback", # 後で　callback_oauth_url　に差し替え
      scope: SCOPE
    )

    redirect_to oauth_uri.to_s, allow_other_host: true
  end
end
