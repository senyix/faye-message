require "faye"

Faye::WebSocket.load_adapter("puma")
faye = Faye::RackAdapter.new(mount: "/faye", timeout: 25)
run faye
