module Google
  class User
    class ClientError < StandardError; end
    attr_reader :response

    def initialize(access_token)
      @access_token = access_token
      @response = HTTParty.get(
        "https://www.googleapis.com/userinfo/v2/me",
        headers: { "Authorization" => "Bearer #{access_token}" }
      )
      raise ClientError, @response.body unless @response.success?
    end

    def id
      response['id']
    end

    def email
      response['email']
    end

    def name
      response['name']
    end

    def photo_url
      response['picture']
    end
  end
end
