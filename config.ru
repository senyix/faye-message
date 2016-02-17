require "yaml"
require "rack"
require "faye"
require "faye/redis"

require File.expand_path("../config/initializers/faye.rb", __FILE__)

class TokenAuthentication
  def incoming(message, callback)
    message["error"] = "Invalid authentication token" if invalid_auth_token?(message)
    callback.call(message)
  end

  private

  def invalid_auth_token?(message)
    message["channel"] !~ %r{^/meta/} && message["ext"]["auth_token"] != FAYE_CONFIG[:secret_token]
  end
end

Faye::WebSocket.load_adapter("puma")
faye = Faye::RackAdapter.new(
  mount: "/faye",
  timeout: 25,
  engine: {
    type: Faye::Redis,
    host: FAYE_CONFIG[:redis_host],
    port: FAYE_CONFIG[:redis_port]
  }
)
faye.add_extension(TokenAuthentication.new)
run faye
