defmodule KvUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # This defines a release named foo with both
      # kv_server and kv applications. Their mode
      # is set to :permanent, which means that,
      # if those applications crash, the whole node
      # terminates.
      releases: [
        foo: [
          version: "0.0.1",
          applications: [kv_server: :permanent, kv: :permanent],
          cookie: "weknoweachother"
        ],
        # bar does not include the server
        bar: [
          version: "0.0.1",
          applications: [kv: :permanent],
          cookie: "weknoweachother"
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end
end
