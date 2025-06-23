class JsonWebToken
  SECRET_KEY = ENV['JWT_SECRET_KEY'] || Rails.application.credentials.jwt_secret_key!
  ALGORITHM = 'HS256'

  def self.encode(payload, exp = 24.hours.from_now.to_i)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY, true, algorithm: ALGORITHM).first
  rescue JWT::DecodeError => e
    nil
  end
end
