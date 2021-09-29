defmodule FlyMultiRegion.MixProject do
  use Mix.Project

  def project do
    [
      app: :fly_multi_region,
      description: "A library for using Fly.io's Multi-Region Databases with Ecto.",
      version: "0.0.1",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:ecto_sql, "~> 3.0"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end
end
