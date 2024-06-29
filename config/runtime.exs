# this file is read after our application
# and dependencies are compiled and therefore
# it can configure how our application works
# at runtime. If you want to read system
# environment variables (via System.get_env/1)
# or any sort of external configuration, this
# is the appropriate place to do so

import Config
# Example
# config :iex, default_prompt: ">>>"
config :kv, :routing_table, [{?a..?z, node()}]

if config_env() == :prod do
  config :kv, :routing_table, [
    {?a..?m, :foo@nixos},
    {?n..?z, :bar@nixos}
  ]
end
