require "net/http"
require "json"
require "uri"

module External
  class TweetsClient
    OAUTH_BASE_URL = "http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com"
    RESPONSE_TYPE = "code"
    GRANT_TYPE = "authorization_code"
    SCOPE = "write_tweet"
    CLIENT_ID = Rails.application.credentials.oauth[:client_id]
    CLIENT_SECRET = Rails.application.credentials.oauth[:client_secret]

    def oauth_authorize_url(redirect_uri:)
      oauth_uri = URI("#{OAUTH_BASE_URL}/oauth/authorize")
      oauth_uri.query = URI.encode_www_form(
        client_id: CLIENT_ID,
        response_type: RESPONSE_TYPE,
        redirect_uri: redirect_uri,
        scope: SCOPE
      )
      oauth_uri.to_s
    end

    def fetch_access_token(code:, redirect_uri:)
      token_uri = URI("#{OAUTH_BASE_URL}/oauth/token")

      http = Net::HTTP.new(token_uri.host, token_uri.port)
      request = Net::HTTP::Post.new(token_uri.path)
      request.set_form_data(
        code: code,
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        redirect_uri: redirect_uri,
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

    def post_tweet(access_token:, text:, url:)
      tweet_api_url = "#{OAUTH_BASE_URL}/api/tweets"
      tweet_uri = URI(tweet_api_url)

      http = Net::HTTP.new(tweet_uri.host, tweet_uri.port)
      request = Net::HTTP::Post.new(tweet_uri.path)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{access_token}"
      request.body = {
        text: text,
        url: url
      }.to_json

      response = http.request(request)

      if response.code == "201"
        Rails.logger.info "Tweet post Success."
        true
      else
        Rails.logger.error "Tweet post failed: status=#{response.code}, body=#{response.body}"
        false
      end
    end
  end
end

