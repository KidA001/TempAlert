# frozen_string_literal: true

module Google
  module OAuth
    extend self

    def auth_uri
      client = client_secrets.to_authorization
      client.update!(:scope => "https://www.googleapis.com/auth/userinfo.email")
      client.authorization_uri.to_s + '&prompt=select_account'
    end

    def fetch_access_token(auth_code)
      client = client_secrets.to_authorization
      client.code = auth_code
      response = client.fetch_access_token!
      response['access_token']
    end

    class << self
      private

      def client_secrets
        Google::APIClient::ClientSecrets.new(
          { "web": {
              "client_id": SECRET[:google_client_id],
              "client_secret": SECRET[:google_client_secret],
              "redirect_uris": [redirect_url],
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://accounts.google.com/o/oauth2/token"
            }
          }
        )
      end
    end

    def redirect_url
      if Rails.env.production?
        "#{SECRET[:production_url]}auth/google_oauth2/callback"
      else
        "http://localhost:3000/auth/google_oauth2/callback"
      end
    end
  end
end
