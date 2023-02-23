defmodule CanvasChamp.MixProject do
  use Mix.Project

  def project do
    [
      app: :canvas_champ,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      extra_applications: [:logger],
      mod: {CanvasChamp.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:finch, "~> 0.14"},
      {:jason, "~> 1.4"},
      {:knigge, "~> 1.4"},

      # only: test
      {:hammox, "~> 0.7", only: :test},

      # only: dev
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end
end
