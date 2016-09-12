class RequestSession
  def initialize(secret:, api_key:, nonce:, hash:)
    @secret, @api_key = secret, api_key
    @nonce = nonce.to_s
    @json = hash.to_json
  end

  def execute
    prepare_signature and send_request
  end

  private

  def prepare_signature
    @signature = OpenSSL::HMAC.hexdigest(
      'sha512', @secret, data.encode('ascii')
    )
  end

  def send_request
    https = Net::HTTP.new(session_uri.host, 443)
    https.use_ssl = true
    req = attach_headers(Net::HTTP::Post.new session_uri.path)

    req.body = @json
    https.request(req)
  end

  def data
    '/v1/session' + @nonce + OpenSSL::Digest::SHA256::hexdigest(@json)
  end

  def attach_headers(req)
    req.add_field 'Content-Type', 'application/vnd.api+json'
    req.add_field 'X-Bg-Api-Key', @api_key
    req.add_field 'X-Bg-Nonce', @nonce
    req.add_field 'X-Bg-Signature', @signature
    req
  end

  def session_uri
    URI.parse(API_BASE_URL + 'v1/session')
  end
end
