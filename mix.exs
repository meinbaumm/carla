defmodule Carla.MixProject do
  use Mix.Project

  def project do
    [
      app: :carla,
      version: "1.0.0",
      elixir: "~> 1.13",
      escript: escript(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def escript do
    [
      main_module: Carla,
      path: "script/carla"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:unicode, "~> 1.15"},
      {:recase, "~> 0.7"}
    ]
  end
end
