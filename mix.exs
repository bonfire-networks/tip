defmodule Tip.MixProject do
  use Mix.Project

  def project do
    [
      app: :tip,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: Mix.compilers() ++ [:protocol_ex],
      deps: [{:protocol_ex, "~> 0.4", optional: true}]
    ]
  end

  def application, do: []
end
