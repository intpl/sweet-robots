API_BASE_URL = 'https://api.demo-games.net/'
GAME_ID = '55f2dc4eba36f81935000001'

class RequestSession
  def initialize(secret:, api_key:, nonce:)
    @secret, @api_key, @nonce = secret, api_key, nonce.to_s
  end

  def execute
    prepare_signature and send
  end

  private

  def prepare_signature
    OpenSSL::HMAC.hexdigest(
      'sha512', @secret.encode('ascii'), data.encode('ascii')
    )
  end

  def send
    https = Net::HTTP.new(session_uri.host, 443)
    https.use_ssl = true
    req = attach_headers(Net::HTTP::Post.new session_uri.path)

    req.body = request_body_json
    https.request(req)
  end

  def data
    session_uri.to_s + @nonce + OpenSSL::Digest::SHA256::hexdigest(request_body_json).encode('ascii')
  end

  def attach_headers(req)
    req.add_field 'Content-Type', 'application/vnd.api+json'
    req.add_field 'X-Bg-Api-Key', @api_key
    req.add_field 'X-Bg-Nonce', @nonce
    req.add_field 'X-Bg-Signature', @signature
    req
  end

  def request_body_json
    { game_id: GAME_ID,
      balance: "123.45", locale: "en",
      currency: "EUR", player_id: "asdf",
    }.to_json
  end

  def session_uri
    URI.parse(API_BASE_URL + 'v1/session/')
  end
end
