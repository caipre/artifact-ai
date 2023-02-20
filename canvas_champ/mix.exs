defmodule CanvasChamp.MixProject do
  use Mix.Project

  def project do
    [
      app: :canvas_champ,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:finch, "~> 0.14"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end
end